import { worldMap, isLaunchable } from '../data/world-map.js';
import { escapeHtml } from '../profile/profile.js';
import { buildLegacySsoUrl } from '../auth/session.js';

function placeCard(place, session) {
  const status = place.state === 'available-legacy' ? 'Study OS · hiện tại' : 'Sắp mở';
  const href = isLaunchable(place) ? buildLegacySsoUrl(place.href, session) : '';
  const action = isLaunchable(place)
    ? `<a class="place-action" href="${escapeHtml(href)}" target="_blank" rel="noopener noreferrer">Mở runtime Study OS <span aria-hidden="true">↗</span></a>`
    : '<span class="place-action place-action-disabled">Sắp mở</span>';
  return `<article class="place-card ${place.state === 'planned' ? 'place-planned' : ''}"><div class="place-top"><span class="place-emblem" aria-hidden="true">${escapeHtml(place.icon)}</span><span class="tag ${place.state === 'planned' ? 'tag-muted' : 'tag-live'}">${status}</span></div><p class="place-area">${escapeHtml(place.area)}</p><h3>${escapeHtml(place.title)}</h3><p class="place-description">${escapeHtml(place.description)}</p>${action}</article>`;
}

export function renderWorldMap(session) {
  return `<section class="world-intro"><div class="world-copy"><p class="eyebrow">HIU TMC GAME HUB</p><h1>BẢN ĐỒ HỌC THUẬT</h1><p>Không gian tập trung các trò chơi học thuật Y học cổ truyền của HIU TMC. Gia Viên Dược Thảo và HIU Y Quán hiện vẫn chạy tại Study OS trong giai đoạn chuyển tiếp.</p><div class="world-legend"><span><i class="legend-dot legend-dot-live"></i>Đang chạy tại Study OS</span><span><i class="legend-dot legend-dot-next"></i>Chuẩn bị theo giai đoạn</span></div></div><div class="world-seal" aria-hidden="true"><span>醫</span><small>HIU · TMC</small></div></section><section class="map-section" aria-label="Bản đồ học thuật"><div class="section-heading"><div><p class="eyebrow">BẢN ĐỒ HỌC THUẬT</p><h2>Chọn khu vực</h2></div><span class="map-caption">Các khu vực được mở theo từng giai đoạn</span></div><div class="place-grid">${worldMap.map(place => placeCard(place, session)).join('')}</div></section>`;
}
