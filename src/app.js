import { bootstrapSession, logout } from './auth/session.js';
import { readRoute } from './game-engine/router.js';
import { renderShell, renderAccessGate } from './components/shell.js';
import { claimOrGetGardenUnlockReceipt, isVerifiedGardenUnlockReceipt } from './entitlements/garden-unlock.js';
import { mountGarden, unmountGarden } from './games/garden-mount.js';
import { canAccessGameHub } from './auth/garden-beta-access.js';
import { installGlobalErrorReporting, reportGameHubError } from './observability/error-reporting.js';
import { applyDisplayMode, readDisplayModePreference, saveDisplayModePreference } from './ui/display-mode.js';

const root = document.querySelector('#app');
let currentMember = null;
let currentSession = null;
let currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
let authError = null;
let displayModePreference = readDisplayModePreference();
let deferredInstallPrompt = null;

function isStandalonePwa() {
  return window.matchMedia?.('(display-mode: standalone)').matches || navigator.standalone === true;
}

function attachDisplayModeControl() {
  const control = root.querySelector('#device-mode-select');
  if (!control) return;
  control.value = displayModePreference;
  control.addEventListener('change', () => {
    displayModePreference = saveDisplayModePreference(control.value);
    applyDisplayMode(root, displayModePreference);
  });
}

function attachInstallButton() {
  root.querySelector('#install-app')?.addEventListener('click', async () => {
    if (!deferredInstallPrompt) {
      root.querySelector('#install-help')?.showModal();
      return;
    }
    const prompt = deferredInstallPrompt;
    deferredInstallPrompt = null;
    try {
      await prompt.prompt();
      const choice = await prompt.userChoice;
      if (choice?.outcome === 'accepted') render();
    } catch {
      root.querySelector('#install-help')?.showModal();
    }
  });
}

window.addEventListener('beforeinstallprompt', event => {
  event.preventDefault();
  deferredInstallPrompt = event;
});
window.addEventListener('appinstalled', () => {
  deferredInstallPrompt = null;
  render();
});

function attachLogout() {
  root.querySelector('#logout-button')?.addEventListener('click', async () => {
    await logout();
    currentMember = null;
    currentSession = null;
    currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
    authError = null;
    render();
  });
}

async function retryBetaVerification() {
  if (!currentSession || !canAccessGameHub(currentMember)) return;
  currentEntitlement = { eligible: false, reason: 'checking' };
  render();
  currentEntitlement = await claimOrGetGardenUnlockReceipt(currentSession);
  render();
}

function attachRetry() {
  root.querySelector('#beta-retry')?.addEventListener('click', retryBetaVerification);
}

function render() {
  applyDisplayMode(root, displayModePreference);
  const canInstall = !isStandalonePwa();
  if (!canAccessGameHub(currentMember)) {
    root.innerHTML = renderAccessGate({ member: currentMember, authError, displayMode: displayModePreference, canInstall });
    attachDisplayModeControl();
    attachInstallButton();
    root.setAttribute('aria-busy', 'false');
    attachLogout();
    return;
  }

  if (!isVerifiedGardenUnlockReceipt(currentEntitlement)) {
    const checking = currentEntitlement.reason === 'checking';
    const message = currentEntitlement.reason === 'identity_unlinked'
      ? 'Tài khoản HIU TMC chưa được duyệt hoặc chưa bật đăng nhập.'
      : currentEntitlement.reason === 'unavailable'
        ? 'Chưa kết nối được máy chủ xác minh. Hãy thử lại sau.'
        : null;
    root.innerHTML = renderAccessGate({
      member: currentMember,
      loading: checking,
      authError: message,
      canRetry: currentEntitlement.reason === 'unavailable',
      displayMode: displayModePreference,
      canInstall
    });
    attachDisplayModeControl();
    attachInstallButton();
    root.setAttribute('aria-busy', checking ? 'true' : 'false');
    attachLogout();
    attachRetry();
    return;
  }

  const route = readRoute();
  const requestedView = route[0];
  const gardenBetaEnabled = true;
  const view = requestedView === 'garden-continuation' && isVerifiedGardenUnlockReceipt(currentEntitlement)
    ? 'garden-continuation'
    : requestedView === 'skills' || requestedView === 'achievements' ? requestedView : 'world';
  root.innerHTML = renderShell({
    member: currentMember,
    session: currentSession,
    entitlement: currentEntitlement,
    gardenBetaEnabled,
    view,
    authError,
    displayMode: displayModePreference,
    canInstall
  });
  attachDisplayModeControl();
  attachInstallButton();
  root.setAttribute('aria-busy', 'false');
  unmountGarden();
  const gardenRoot = root.querySelector('#garden-runtime-root');
  if (gardenRoot && currentMember && isVerifiedGardenUnlockReceipt(currentEntitlement)) mountGarden(gardenRoot, currentMember);
  root.querySelector('#garden-unlock-retry')?.addEventListener('click', retryBetaVerification);
  attachLogout();
}

root.innerHTML = renderAccessGate({ loading: true, displayMode: displayModePreference, canInstall: !isStandalonePwa() });
applyDisplayMode(root, displayModePreference);
attachDisplayModeControl();
attachInstallButton();
installGlobalErrorReporting(() => currentSession);
bootstrapSession().then(async result => {
  currentMember = result.member;
  currentSession = result.session;
  authError = result.error;
  if (currentMember && currentSession && canAccessGameHub(currentMember)) {
    currentEntitlement = { eligible: false, reason: 'checking' };
    render();
    currentEntitlement = await claimOrGetGardenUnlockReceipt(currentSession);
  } else {
    currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
  }
  render();
}).catch(error => {
  authError = error instanceof Error ? error.message : 'Không thể xác minh phiên HIU TMC.';
  void reportGameHubError(currentSession, error, { code: 'session_bootstrap', area: 'access', operation: 'bootstrapSession' });
  render();
});

window.addEventListener('resize', () => {
  if (displayModePreference === 'auto') applyDisplayMode(root, displayModePreference);
}, { passive: true });
window.addEventListener('hashchange', () => {
  const reduceMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;
  if (document.startViewTransition && !reduceMotion) {
    document.startViewTransition(() => render());
  } else {
    render();
  }
});
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker.register('/service-worker.js').catch(error => {
  void reportGameHubError(currentSession, error, { code: 'service_worker_register', area: 'runtime', operation: 'register' });
}));
