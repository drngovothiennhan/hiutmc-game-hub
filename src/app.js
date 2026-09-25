import { bootstrapSession, logout } from './auth/session.js';
import { readRoute } from './game-engine/router.js';
import { renderShell } from './components/shell.js';
import { claimOrGetGardenUnlockReceipt, isVerifiedGardenUnlockReceipt } from './entitlements/garden-unlock.js';
import { mountGarden, unmountGarden } from './games/garden-mount.js';
import { canAccessGardenBeta } from './auth/garden-beta-access.js';

const root = document.querySelector('#app');
let currentMember = null;
let currentSession = null;
let currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
let authError = null;

function render() {
  const route = readRoute();
  const requestedView = route[0];
  const gardenBetaEnabled = canAccessGardenBeta(currentMember);
  const view = requestedView === 'garden-continuation' && gardenBetaEnabled && isVerifiedGardenUnlockReceipt(currentEntitlement)
    ? 'garden-continuation'
    : requestedView === 'skills' || requestedView === 'achievements' ? requestedView : 'world';
  root.innerHTML = renderShell({
    member: currentMember,
    session: currentSession,
    entitlement: currentEntitlement,
    gardenBetaEnabled,
    view,
    authError
  });
  root.setAttribute('aria-busy', 'false');
  unmountGarden();
  const gardenRoot = root.querySelector('#garden-runtime-root');
  if (gardenRoot && gardenBetaEnabled && currentMember && isVerifiedGardenUnlockReceipt(currentEntitlement)) mountGarden(gardenRoot, currentMember);
  root.querySelector('#garden-unlock-retry')?.addEventListener('click', async () => {
    if (!currentSession || !canAccessGardenBeta(currentMember)) return;
    currentEntitlement = { eligible: false, reason: 'checking' };
    render();
    currentEntitlement = await claimOrGetGardenUnlockReceipt(currentSession);
    render();
  });
  root.querySelector('#logout-button')?.addEventListener('click', async () => {
    await logout();
    currentMember = null;
    currentSession = null;
    currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
    authError = null;
    render();
  });
}

root.innerHTML = renderShell({ member: null, view: 'world', loading: true });
bootstrapSession().then(async result => {
  currentMember = result.member;
  currentSession = result.session;
  authError = result.error;
  render();

  if (currentMember && currentSession && canAccessGardenBeta(currentMember)) {
    currentEntitlement = { eligible: false, reason: 'checking' };
    render();
    currentEntitlement = await claimOrGetGardenUnlockReceipt(currentSession);
    render();
  } else if (currentMember) {
    currentEntitlement = { eligible: false, reason: 'role_restricted' };
    render();
  }
}).catch(error => {
  authError = error instanceof Error ? error.message : 'Không thể xác minh phiên HIU TMC.';
  render();
});

window.addEventListener('hashchange', render);
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker.register('/service-worker.js').catch(() => {}));
