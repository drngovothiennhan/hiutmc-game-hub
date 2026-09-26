import { bootstrapSession, logout } from './auth/session.js';
import { readRoute } from './game-engine/router.js';
import { renderShell, renderAccessGate, renderDisplayModeToggle } from './components/shell.js';
import { claimOrGetGardenUnlockReceipt, isVerifiedGardenUnlockReceipt } from './entitlements/garden-unlock.js';
import { mountGarden, unmountGarden } from './games/garden-mount.js';
import { canAccessGameHub } from './auth/garden-beta-access.js';
import { installGlobalErrorReporting, reportGameHubError } from './observability/error-reporting.js';
import { createDisplayModeController } from './ui/display-mode.js';

const root = document.querySelector('#app');
const displayMode = createDisplayModeController();
displayMode.init();
let currentMember = null;
let currentSession = null;
let currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
let authError = null;

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

function attachDisplayModeToggle() {
  root.querySelectorAll('[data-display-mode-toggle]').forEach(bindDisplayModeToggle);
}

function bindDisplayModeToggle(button) {
  button.addEventListener('click', () => {
    const replacement = document.createElement('template');
    replacement.innerHTML = renderDisplayModeToggle(displayMode.cycle());
    const nextButton = replacement.content.firstElementChild;
    button.replaceWith(nextButton);
    bindDisplayModeToggle(nextButton);
    nextButton.focus({ preventScroll: true });
  });
}

function setRootMarkup(markup) {
  root.classList.remove('view-enter');
  root.innerHTML = markup;
  void root.offsetWidth;
  root.classList.add('view-enter');
  attachDisplayModeToggle();
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
  if (!canAccessGameHub(currentMember)) {
    setRootMarkup(renderAccessGate({ member: currentMember, authError, displayMode: displayMode.snapshot() }));
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
    setRootMarkup(renderAccessGate({
      member: currentMember,
      loading: checking,
      authError: message,
      canRetry: currentEntitlement.reason === 'unavailable',
      displayMode: displayMode.snapshot()
    }));
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
  setRootMarkup(renderShell({
    member: currentMember,
    session: currentSession,
    entitlement: currentEntitlement,
    gardenBetaEnabled,
    view,
    authError,
    displayMode: displayMode.snapshot()
  }));
  root.setAttribute('aria-busy', 'false');
  unmountGarden();
  const gardenRoot = root.querySelector('#garden-runtime-root');
  if (gardenRoot && currentMember && isVerifiedGardenUnlockReceipt(currentEntitlement)) mountGarden(gardenRoot, currentMember);
  root.querySelector('#garden-unlock-retry')?.addEventListener('click', retryBetaVerification);
  attachLogout();
}

setRootMarkup(renderAccessGate({ loading: true, displayMode: displayMode.snapshot() }));
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

window.addEventListener('hashchange', render);
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker
  .register('/service-worker.js', { updateViaCache: 'none' })
  .then(registration => registration.update())
  .catch(error => {
    void reportGameHubError(currentSession, error, { code: 'service_worker_register', area: 'runtime', operation: 'register' });
  }));
