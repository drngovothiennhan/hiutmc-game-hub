import { worldMap, isLaunchable } from '../data/world-map.js';
import { escapeHtml } from '../profile/profile.js';
import { buildLegacySsoUrl } from '../auth/session.js';

function placeCard(place, session) {
  const legacy = place.state === 'available-legacy';
  const lockedSequel = place.state === 'locked-sequel';
  const status = legacy ? 'Study OS · hiện tại' : lockedSequel ? 'Khóa · cần hoàn thành Gia Viên' : 'Sắp mở';
  const href = isLaunchable(place) ? buildLegacySsoUrl(place.href, session) : '';
  const action = isLaunchable(place)
    ? `<a class="place-action" href="${escapeHtml(href)}" target="_blank" rel="noopener noreferrer">Mở runtime Study OS <span aria-hidden="true">↗</span></a>`
    : lockedSequel
      ? '<span class="place-action place-action-disabled">Mở sau khi hoàn thành Gia Viên</span>'
      : '<span class="place-action place-action-disabled">Sắp mở</span>';
  const cardClass = legacy ? '' : place.state === 'planned' ? 'place-planned' : 'place-locked';
  return `<article class="place-card ${cardClass}" data-place-id="${escapeHtml(place.id)}"><div class="place-top"><span class="place-emblem" aria-hidden="true">${escapeHtml(place.icon)}</span><span class="tag ${legacy ? 'tag-live' : 'tag-muted'}">${status}</span></div><p class="place-area">${escapeHtml(place.area)}</p><h3>${escapeHtml(place.title)}</h3><p class="place-description">${escapeHtml(place.description)}</p>${action}</article>`;
}

export function renderWorldMap(session) {
  return `<section class="world-intro"><div class="world-copy"><p class="eyebrow">HIU TMC GAME HUB</p><h1>BẢN ĐỒ HỌC THUẬT</h1><p>Không gian tập trung các trò chơi học thuật Y học cổ truyền của HIU TMC. Gia Viên Dược Thảo hiện là trải nghiệm mở đầu tại Study OS; phần tiếp nối Giáo viên Dược thảo sẽ mở tại Game Hub sau khi hệ thống xác nhận hoàn thành.</p><div class="world-legend"><span><i class="legend-dot legend-dot-live"></i>Đang chạy tại Study OS</span><span><i class="legend-dot legend-dot-next"></i>Chuẩn bị theo giai đoạn</span></div></div><div class="world-seal" aria-hidden="true"><span>醫</span><small>HIU · TMC</small></div></section><section class="map-section" aria-label="Bản đồ học thuật"><div class="section-heading"><div><p class="eyebrow">BẢN ĐỒ HỌC THUẬT</p><h2>Chọn khu vực</h2></div><span class="map-caption">Các khu vực được mở theo từng giai đoạn</span></div><div class="place-grid">${worldMap.map(place => placeCard(place, session)).join('')}</div></section>`;
}
