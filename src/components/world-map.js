import { worldMap, isLaunchable } from '../data/world-map.js';
import { escapeHtml } from '../profile/profile.js';
import { buildLegacySsoUrl } from '../auth/session.js';
import { isVerifiedGardenUnlockReceipt } from '../entitlements/garden-unlock.js';

function placeCard(place, session, entitlement, authenticated) {
  const legacy = place.state === 'available-legacy';
  const live = place.state === 'available-live';
  const lockedContinuation = place.state === 'locked-continuation';
  const continuationUnlocked = lockedContinuation && isVerifiedGardenUnlockReceipt(entitlement);
  const pending = lockedContinuation && authenticated && entitlement?.reason === 'checking';
  const status = live
    ? 'Game Hub · đang hoạt động'
    : legacy
    ? 'Study OS · hiện tại'
    : continuationUnlocked
      ? 'Đã mở · thành viên HIU TMC'
      : lockedContinuation ? pending ? 'Đang xác minh quyền vào' : 'Sẵn sàng sau xác minh thành viên' : 'Sắp mở';
  const href = live ? place.href : isLaunchable(place) ? buildLegacySsoUrl(place.href, session) : '';
  const action = live
    ? `<a class="place-action" href="${escapeHtml(href)}">Vào HIU Y Quán <span aria-hidden="true">→</span></a>`
    : isLaunchable(place)
    ? `<a class="place-action" href="${escapeHtml(href)}" target="_blank" rel="noopener noreferrer">Mở runtime Study OS <span aria-hidden="true">↗</span></a>`
    : continuationUnlocked
      ? '<a class="place-action" href="#/garden-continuation">Tiếp tục Gia Viên <span aria-hidden="true">→</span></a>'
      : pending
        ? '<span class="place-action place-action-disabled" role="status">Đang xác minh điều kiện…</span>'
        : lockedContinuation && authenticated
          ? '<button class="place-action place-action-button" id="garden-unlock-retry" type="button">Thử xác minh lại</button>'
          : lockedContinuation
            ? '<span class="place-action place-action-disabled">Đăng nhập HIU TMC để vào chơi</span>'
            : '<span class="place-action place-action-disabled">Sắp mở</span>';
  const cardClass = legacy || live ? '' : continuationUnlocked ? 'place-unlocked' : place.state === 'planned' ? 'place-planned' : 'place-locked';
  return `<article class="place-card ${cardClass}" data-place-id="${escapeHtml(place.id)}"><div class="place-top"><span class="place-emblem" aria-hidden="true">${escapeHtml(place.icon)}</span><span class="tag ${legacy || live || continuationUnlocked ? 'tag-live' : 'tag-muted'}">${status}</span></div><p class="place-area">${escapeHtml(place.area)}</p><h3>${escapeHtml(place.title)}</h3><p class="place-description">${escapeHtml(place.description)}</p>${action}</article>`;
}

export function renderWorldMap(session, entitlement = null, authenticated = false, gardenBetaEnabled = false) {
  const visiblePlaces = gardenBetaEnabled ? worldMap : worldMap.filter(place => place.id !== 'garden-continuation');
  return `<section class="world-intro"><div class="world-copy"><p class="eyebrow">HIU TMC GAME HUB</p><h1>BẢN ĐỒ HỌC THUẬT</h1><p>Không gian tập trung các trò chơi học thuật Y học cổ truyền của HIU TMC. Gia Viên Dược Thảo đang mở cho thành viên HIU TMC đã được duyệt; SSO xác minh tài khoản và lưu tiến trình theo đúng chủ vườn.</p><div class="world-legend"><span><i class="legend-dot legend-dot-live"></i>Đang chạy tại Study OS</span><span><i class="legend-dot legend-dot-next"></i>Chuẩn bị theo giai đoạn</span></div></div><div class="world-seal" aria-hidden="true"><span>醫</span><small>HIU · TMC</small></div></section><section class="map-section" aria-label="Bản đồ học thuật"><div class="section-heading"><div><p class="eyebrow">BẢN ĐỒ HỌC THUẬT</p><h2>Chọn khu vực</h2></div><span class="map-caption">Các khu vực được mở theo từng giai đoạn</span></div><div class="place-grid">${visiblePlaces.map(place => placeCard(place, session, entitlement, authenticated)).join('')}</div></section>`;
}
