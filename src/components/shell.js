import { ECOSYSTEM_HOME, HUB_NAME } from '../config.js';
import { renderProfile } from '../profile/profile.js';
import { renderSkillMatrix } from '../skill-matrix/skill-matrix.js';
import { renderAchievements } from '../achievements/achievements.js';
import { renderWorldMap } from './world-map.js';

export function renderShell({ member, session = null, entitlement = null, gardenBetaEnabled = false, view = 'world', authError = null, loading = false, displayMode = { preference: 'auto', effective: 'mobile' } }) {
  const content = view === 'skills'
    ? renderSkillMatrix()
    : view === 'achievements'
      ? renderAchievements()
      : view === 'garden-continuation'
        ? '<section class="garden-runtime-shell"><p class="eyebrow">GIA VIÊN · QUYỀN VÀO ĐÃ XÁC MINH</p><h1>Gia Viên Dược Thảo · Khu vườn mở rộng</h1><p>Tiến trình trước đó tại Study OS được giữ nguyên. Bạn đang tiếp tục Gia Viên trong Game Hub.</p><div id="garden-runtime-root"></div></section>'
        : renderWorldMap(session, entitlement, Boolean(member), gardenBetaEnabled);
  const account = member
    ? `<button class="account-button" id="logout-button" type="button">Đăng xuất</button>`
    : `<a class="account-button" href="${ECOSYSTEM_HOME}" rel="noopener">HIU TMC</a>`;
  const alert = authError ? `<div class="notice notice-error" role="alert">${escapeText(authError)}</div>` : '';
  const pending = loading ? '<div class="notice" role="status">Đang xác minh phiên HIU TMC…</div>' : '';
  return `<div class="app-shell"><header class="topbar"><a class="brand" href="#/world" aria-label="${HUB_NAME} - trang bản đồ"><span class="brand-mark" aria-hidden="true">醫</span><span><strong>HIU TMC</strong><small>GAME HUB</small></span></a><nav class="topnav" aria-label="Điều hướng chính"><a href="#/world" data-view="world">Bản đồ</a><a href="#/skills" data-view="skills">Năng lực</a><a href="#/achievements" data-view="achievements">Thành tựu</a></nav>${renderDisplayModeToggle(displayMode)}<div class="topbar-account">${account}</div></header><main class="main-content">${alert}${pending}<div class="content-grid"><div class="primary-content">${content}</div><aside class="side-column">${renderProfile(member)}<section class="card learning-note"><p class="eyebrow">NGUYÊN TẮC HỌC</p><h2>Năng lực đi trước điểm số</h2><p>Hoạt động học thuật cần có lựa chọn của người học, phản hồi giải thích và kết quả được hệ thống xác minh.</p></section></aside></div></main><footer class="footer"><span>HIU TMC Game Hub · Bản đồ học thuật</span><a href="${ECOSYSTEM_HOME}" rel="noopener">Về HIU TMC ↗</a></footer></div>`;
}

export function renderDisplayModeToggle(displayMode = { preference: 'auto', effective: 'mobile' }) {
  const labels = { auto: 'Tự động', mobile: 'Mobile', pc: 'PC' };
  const preference = Object.hasOwn(labels, displayMode.preference) ? displayMode.preference : 'auto';
  const effective = displayMode.effective === 'pc' ? 'PC' : 'Mobile';
  const label = preference === 'auto' ? `Tự động · ${effective}` : labels[preference];
  const next = preference === 'auto' ? 'Mobile' : preference === 'mobile' ? 'PC' : 'Tự động';
  return `<button class="display-mode-toggle" data-display-mode-toggle type="button" aria-label="Chế độ hiển thị: ${label}. Chuyển sang ${next}." title="Đang dùng ${label}. Nhấn để chuyển sang ${next}."><span class="display-mode-icon" aria-hidden="true">▣</span><span>${label}</span></button>`;
}

function escapeText(value) {
  return String(value).replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
}

export function renderAccessGate({ member = null, loading = false, authError = null, canRetry = false, displayMode = { preference: 'auto', effective: 'mobile' } } = {}) {
  const heading = loading ? 'Đang xác minh quyền beta' : member ? 'Chưa thể vào beta' : 'Đăng nhập để tiếp tục';
  const message = loading
    ? 'Game Hub đang xác minh tài khoản HIU TMC đã được duyệt và bật đăng nhập.'
    : member
      ? 'Beta dành cho mọi thành viên HIU TMC đã được duyệt và bật đăng nhập.'
      : 'Hãy đăng nhập qua hệ sinh thái HIU TMC bằng tài khoản thành viên.';
  const alert = authError ? `<div class="notice notice-error" role="alert">${escapeText(authError)}</div>` : '';
  const retry = canRetry ? '<button class="account-button" id="beta-retry" type="button">Thử xác minh lại</button>' : '';
  const action = member
    ? `<div class="access-gate-actions">${retry}<button class="account-button" id="logout-button" type="button">Đăng xuất</button></div>`
    : `<a class="account-button" href="${ECOSYSTEM_HOME}?open=game-hub" rel="noopener">Tiếp tục vào Game Hub ↗</a>`;
  return `<main class="access-gate"><div class="access-gate-mode">${renderDisplayModeToggle(displayMode)}</div><section class="access-gate-card" role="status"><p class="eyebrow">HIU TMC GAME HUB</p><h1>${heading}</h1><p>${message}</p>${alert}<div class="access-gate-action">${action}</div></section></main>`;
}
