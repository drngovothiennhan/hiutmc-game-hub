# Y Quán · Admin preview

This is a review build on the isolated `g5/admin-y-quan-practice` branch of HIU TMC Game Hub. It is deployed only to that Cloudflare Pages branch preview. The production branch and the existing Study OS Y Quán runtime are untouched.

## Access

- The world-map tile is rendered only for members whose `role` comes from the Game Hub's verified HIU TMC Supabase `app_metadata`.
- `/y-quan-practice/` independently calls the existing Supabase Auth user endpoint and checks `app_metadata.member_id` plus an explicit admin role allowlist before it shows the game.
- The GitHub Actions Playwright test uses a mocked admin response only to validate preview behavior; the test does not write to Supabase.

## Data boundary

- The only playable record is the bundled, version-pinned fictional review fixture. It is marked `PUBLISHED` within this gated preview so the published-only gate can be exercised; this is not academic approval or student availability.
- Consultation sessions are stored in browser local storage under a per-member preview key. They do not use Game Hub production game-save APIs, Supabase tables, points, or member progress.
- The patient bot returns only the response attached to a question in this case. Unknown/free-text requests receive the fixed neutral response.
- The preview has no prescription generator or treatment recommendations. Learning checklist feedback is educational and explicitly pending lecturer review.
- Both required avatar image paths are served from the Game Hub static assets.

## Release gate

Before enabling this activity for students, a YHCT lecturer must review and approve the case profile, answer wording, diagnosis rubric, reasoning rubric, and learning plan. A separate release must add an authorized case publication workflow and approved persistence design. Keep this admin preview branch isolated until those reviews pass.
