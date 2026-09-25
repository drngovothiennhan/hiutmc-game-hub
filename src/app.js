import { bootstrapSession, logout } from './auth/session.js';
import { readRoute } from './game-engine/router.js';
import { renderShell } from './components/shell.js';

const root = document.querySelector('#app');
let currentMember = null;
let currentSession = null;
let authError = null;

function render() {
  const route = readRoute();
  const view = route[0] === 'skills' || route[0] === 'achievements' ? route[0] : 'world';
  root.innerHTML = renderShell({ member: currentMember, session: currentSession, view, authError });
  root.setAttribute('aria-busy', 'false');
  root.querySelector('#logout-button')?.addEventListener('click', async () => {
    await logout();
  currentMember = null;
    currentSession = null;
    authError = null;
    render();
  });
}

root.innerHTML = renderShell({ member: null, view: 'world', loading: true });
bootstrapSession().then(result => {
currentMember = result.member;
  currentSession = result.session;
  authError = result.error;
  render();
}).catch(error => {
  authError = error instanceof Error ? error.message : 'Không thể xác minh phiên HIU TMC.';
  render();
});

window.addEventListener('hashchange', render);
if ('serviceWorker' in navigator) window.addEventListener('load', () => navigator.serviceWorker.register('/service-worker.js').catch(() => {}));
