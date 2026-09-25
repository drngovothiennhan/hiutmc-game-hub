# Game Hub introduction and layout handoff

**Status:** UX implementation brief for the Garden extraction. No production layout or gameplay was changed by this document.

## Position and navigation

- Give the Game Hub its own landing page and clear identity: “HIU TMC Game Hub — Bản đồ học thuật”.
- Keep the primary page hierarchy: introductory identity → available game locations → member profile/progress → clearly marked future locations.
- Use separate, direct routes for modules. Each module page has a consistent top bar with Game Hub mark, current location, profile/session status, and “Quay lại Game Hub”.
- Garden entry is shown as a Hub runtime only after the Garden route, SSO, and save-parity gates pass. Until then, retain the existing Study OS link and label it as runtime hiện tại.
- Keep HIU Y Quán linked to its Study OS runtime until its separately planned extraction phase. Do not route it through the Garden migration.

## Introductory copy (verified scope only)

**Title:** HIU TMC Game Hub  
**Description:** “Không gian tập trung các trò chơi học thuật Y học cổ truyền của HIU TMC. Gia Viên Dược Thảo đang được tách theo từng giai đoạn; HIU Y Quán hiện tiếp tục chạy tại Study OS.”  
**Status labels:** “Đang chạy tại Study OS”, “Đang chuẩn bị chuyển”, “Sắp ra mắt” only when backed by branch/preview status. Do not imply a module is live in the Hub before its release gate passes.

## Garden page layout

- Desktop/tablet landscape: narrow fixed navigation/header; garden scene and nine-plot board as the central work area; inventory, seed bag and wallet in a compact side panel; action details below/alongside the selected plot.
- Mobile: single-column layout; scene first, plot selector immediately below, then separate seed bag / harvested inventory / wallet cards. Keep primary actions full-width and text-wrapped; no clipped action labels.
- Preserve the existing Garden artwork, sprite IDs, and gameplay language first. Avoid redrawing the game scene during extraction.
- Keep status and action messages adjacent to the selected plot. Do not place critical care timers only in decorative scenery.
- Respect display mode, keyboard focus, reduced motion, safe-area insets, and horizontal overflow checks.

## Visual identity and assets

- Reuse the current Game Hub shell palette and logos where it does not alter the existing Garden art or reduce contrast.
- Reuse `garden-decor-sprite.svg` and the current scene assets. Do not invent new botanical illustrations or data for this migration.
- Isolate legacy Garden CSS in a dedicated entry/route so its global selectors do not change the rest of the Hub.
- Verify asset paths on Cloudflare Pages preview, including nested `/garden/` URLs and refresh/deep links.

## Release criteria

The introduction must accurately distinguish live modules, modules still hosted in Study OS, and planned areas. The old Garden route remains available until Hub SSO, state parity, deep link, mobile/tablet layout, and isolated gameplay QA all pass.
