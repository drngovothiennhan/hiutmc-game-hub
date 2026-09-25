import { bootstrapSession, logout } from './auth/session.js';
import { readRoute } from './game-engine/router.js';
import { renderShell } from './components/shell.js';
import { claimOrGetTeacherHerbEntitlement, isVerifiedTeacherHerbEntitlement } from './entitlements/teacher-herb.js';

const root = document.querySelector('#app');
let currentMember = null;
let currentSession = null;
let currentEntitlement = { eligible: false, reason: 'identity_unlinked' };
let authError = null;

function render() {
  const route = readRoute();
  const requestedView = route[0];
  const view = requestedView === 'teacher-herb' && isVerifiedTeacherHerbEntitlement(currentEntitlement)
    ? 'teacher-herb'
    : requestedView === 'skills' || requestedView === 'achievements' ? requestedView : 'world';
  root.innerHTML = renderShell({
    member: currentMember,
    session: currentSession,
    entitlement: currentEntitlement,
    view,
    authError
  });
  root.setAttribute('aria-busy', 'false');
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

  if (currentMember && currentSession) {
    currentEntitlement = { eligible: false, reason: 'checking' };
    render();
    currentEntitlement = await claimOrGetTeacherHerbEntitlement(currentSession);
    render();
  }
}).catch(error => {
  authError = error instanceof Error ? error.message : 'Không thể xác minh phiên HIU TMC.';
  render();
});

window.addEventListener('hashchange', render);
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker.register('/service-worker.js').catch(() => {}));
