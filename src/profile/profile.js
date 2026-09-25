export function renderProfile(member) {
  if (!member) return '<section class="card profile-card"><p class="eyebrow">HỒ SƠ NGƯỜI HỌC</p><h2>Chưa có phiên đăng nhập</h2><p>Hãy mở Game Hub từ hệ sinh thái HIU TMC sau khi liên kết đăng nhập được bật.</p></section>';
  const avatarUrl = safeAvatarUrl(member.avatarUrl);
  const avatar = avatarUrl
    ? `<img class="avatar" src="${escapeHtml(avatarUrl)}" alt="Ảnh đại diện của ${escapeHtml(member.displayName)}" />`
    : '<span class="avatar avatar-fallback" aria-hidden="true">☯</span>';
  return `<section class="card profile-card"><p class="eyebrow">HỒ SƠ NGƯỜI HỌC</p><div class="profile-row">${avatar}<div><h2>${escapeHtml(member.displayName)}</h2><p>${escapeHtml(member.role)}</p></div></div><p class="profile-note">Hồ sơ được xác minh qua tài khoản HIU TMC.</p></section>`;
}

function safeAvatarUrl(value) {
  try {
    const url = new URL(String(value || ''));
    return url.protocol === 'https:' ? url.href : '';
  } catch {
    return '';
  }
}

export function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
}
