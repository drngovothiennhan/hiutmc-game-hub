import { bootstrapSession, logout } from './auth/session.js';
import { isGameHubAdmin } from './auth/roles.js';
import { readRoute } from './game-engine/router.js';
import { renderShell } from './components/shell.js';
import { claimOrGetGardenUnlockReceipt, isVerifiedGardenUnlockReceipt } from './entitlements/garden-unlock.js';
import { mountGarden, unmountGarden } from './games/garden-mount.js';

// Build-only safety switch: the admin review preview must not invoke an RPC
// that can claim a production Garden receipt while its operator opens the Hub.
const ADMIN_PREVIEW_BUILD = __GAME_HUB_ADMIN_PREVIEW__;
const root = document.querySelector('#app');
let currentMember = null;
let currentSession = null;
let currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
let authError = null;

function render() {
  const route = readRoute();
  const requestedView = route[0];
  const view = requestedView === 'garden-continuation' && isVerifiedGardenUnlockReceipt(currentEntitlement)
    ? 'garden-continuation'
    : requestedView === 'skills' || requestedView === 'achievements' ? requestedView : 'world';
  root.innerHTML = renderShell({
    member: currentMember,
    session: currentSession,
    entitlement: currentEntitlement,
    view,
    authError
  });
  root.setAttribute('aria-busy', 'false');
  unmountGarden();
  const gardenRoot = root.querySelector('#garden-runtime-root');
  if (gardenRoot && currentMember && isVerifiedGardenUnlockReceipt(currentEntitlement)) mountGarden(gardenRoot, currentMember);
  root.querySelector('#garden-unlock-retry')?.addEventListener('click', async () => {
    if (!currentSession) return;
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

  // Outside this explicitly isolated preview build, preserve the existing
  // receipt lookup for all signed-in members. On the preview, skip it for an
  // Admin so opening the test activity cannot mutate a production game receipt.
  const isIsolatedPreviewAdmin = ADMIN_PREVIEW_BUILD && isGameHubAdmin(currentMember);
  if (currentMember && currentSession && !isIsolatedPreviewAdmin) {
    currentEntitlement = { eligible: false, reason: 'checking' };
    render();
    currentEntitlement = await claimOrGetGardenUnlockReceipt(currentSession);
    render();
  }
}).catch(error => {
  authError = error instanceof Error ? error.message : 'Không thể xác minh phiên HIU TMC.';
  render();
});

window.addEventListener('hashchange', render);
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker.register('/service-worker.js').catch(() => {}));
