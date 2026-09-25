# HIU TMC Game Hub — Migration Audit

**Phase:** G1 — Audit & Freeze  
**Audit date:** 2026-09-25  
**Scope:** read-only verification of Study OS, Garden, HIU Y Quán, Supabase, auth/SSO, CI/CD, and current deployment.  
**Production changes during audit:** none. No database writes, game actions, schema changes, or Study OS source changes were made.

## Executive result

The current Study OS contains both games in one React/Vite application. Garden and HIU Y Quán are lazy-loaded game components, but their authoritative state and gameplay RPCs live in the existing Supabase project. A separate Game Hub can be built without moving those records first, provided it calls the same member identity and server-authoritative RPCs.

The production deployment and latest CI for commit `e10987e3b1ad2764f504e1b882c8f4617b5e627f` are successful. The production alias returned HTTP 200, and Vercel reports the deployment `READY` with target `production`.

The named repository `drngovothiennhan/hiutmc-game-hub` returned GitHub 404 and was absent from the connected account's repository list. The available GitHub connection can inspect and push to the existing Study OS repository, but it exposes no repository-creation operation; no local GitHub token/checkout is present. Therefore G2 must not place the new app in the Study OS repository. Creation of the dedicated repo is the current execution blocker.

## Verified system state

| Area | Observed state | Evidence / boundary |
|---|---|---|
| Study OS repo | `drngovothiennhan/yhct-hiu-4-0`, public, default branch `main`; connected account reports admin/push permission. | GitHub repo metadata. Workspace scratch contains no checkout and `git status` cannot run here. |
| Current release commit | `e10987e3b1ad2764f504e1b882c8f4617b5e627f`, message `style(learning): balance five Learning Hub tabs`. | Latest observed Web CI / production workflow commit. |
| Web CI | Web CI run #1120 succeeded on the release commit. Workflow includes Garden water/fertilizer contract checks and HIU Y Quán V20 contract/runtime checks. | GitHub Actions run metadata and `.github/workflows/web-ci.yml`. |
| Production promotion | Vercel Production run #1006 succeeded. | GitHub Actions run metadata. |
| Vercel | Project `yhct-hiu-final4-stage`, deployment `dpl_49daim3nDWb5oX851Lye9fy5yPRc`, `READY`, target `production`, commit matches the release SHA. | Vercel project/deployment API. This is the current configured production alias despite the project name containing “stage”. |
| Live shell | `https://yhct-hiu-final4-stage.vercel.app/garden?game=hiu-y-quan` returned HTTP 200 and the Study OS HTML shell. | Authenticated Vercel URL fetch; this does not prove an authenticated in-browser game session. |
| Supabase | Active/healthy project `gzmpnsrwqjpsbklyflqr` (“drngovothiennhan's Project”), Postgres 17.6.1, region `ap-south-1`. | Supabase project listing and read-only project metadata. Another listed project is inactive and named for Tam Bình health work; it was not treated as a game staging DB. |
| Garden persistence | `herb_garden_plants`, `herb_garden_inventory`, `herb_garden_seed_inventory`, `herb_garden_wallets`, `herb_garden_events`, `herb_garden_plots`, and `herb_garden_profiles` exist. The user-owned rows are keyed by `member_id` referencing `club_members.id`. | Supabase schema/table inspection. No player rows or private member data were read. |
| HIU Y Quán persistence | `hiu_y_quan_profiles`, `hiu_y_quan_cases`, `hiu_y_quan_attempts`, `hiu_y_quan_engagement_profiles`, `hiu_y_quan_mastery`, `hiu_y_quan_herb_challenge_sessions`, and related supporting tables exist and are keyed to the same `club_members` identity. | Supabase schema/table inspection. |
| Auth/SSO | Study OS uses the same Supabase project and `club_members` identity. It has an `ecosystem_sso=1` bridge that transfers the current Supabase access/refresh session in the URL fragment, strips the fragment, then calls `supabase.auth.setSession`. Login also calls the `member-login` Edge Function. | `src/services/authService.ts`; no credentials were read. Hub must reuse the ecosystem identity/session, never create a second password store. |
| Target hub repo | GitHub 404 for the requested name; no repository-creation tool is exposed in this session. | GitHub metadata lookup and connected repository listing. No repo was created. |

## Migration map

| Current component/data | Current owner | Hub migration treatment |
|---|---|---|
| `src/App.tsx` game entry and route selection | Study OS shell | Replace with a “Game học thuật” outbound card only after Hub preview and data compatibility are proven. Keep old routes during the compatibility window. |
| `src/components/game/HerbGardenGame.tsx` | Garden facade / world and sub-game selection | Extract as the Garden module entry after locating its full imports and route contract in a checkout. Keep behavior intact. |
| `src/components/game/HerbGardenGameV7.tsx` | Garden care UI | Move as the current care UI, retaining its existing server RPC requests. Do not reimplement server logic in the browser. |
| `src/components/game/HiuYQuanGameV20.tsx` and `src/components/game/yquan-v20/*` | Canonical HIU Y Quán V20 game runtime | Not part of G3. Migrate only after Garden production is stable (G5); preserve V20 runtime/scene and server contracts. |
| Supabase Garden tables and RPCs | Existing Supabase project | Continue using existing production state and RPC contracts at first. No schema copy or save reset. Any later ownership/schema change requires backup, a migration plan, RLS review, and restore proof. |
| Supabase HIU Y Quán tables/RPCs | Existing Supabase project | Leave in place through G3. Do not migrate during shell or Garden cutover. |
| `src/services/authService.ts` | Study OS / ecosystem identity integration | Build Hub bootstrap against existing `club_members` member ID, role, name, avatar, and current Supabase session. No password copy. Test token/session handling on preview before opening access. |
| `src/modules/moduleContract.ts` and path routing | Study OS routing | Treat `/garden` and game query parameters as compatibility inputs; preserve redirects until Hub deep links and sign-in are verified. |
| `.github/workflows/web-ci.yml`, `.github/workflows/vercel-production.yml` | Study OS CI/release | Do not change for the Hub. Establish separate Hub CI and preview in the new repository. |

## Current safety conditions and unverified areas

1. The live Garden/HIU Y Quán experience was not exercised with a member account. Harvest/water/plant actions can alter saved progress, so no live gameplay transaction was run.
2. No test account or active isolated Supabase branch was verified. The active project is production. G3 acceptance testing needs a dedicated test account on an approved isolated environment or a verified transaction rollback harness; no fake save was created.
3. Read-only introspection confirmed RLS is enabled on the inspected Garden and HIU Y Quán tables. The catalog query returned no table policies for those tables. Existing RPCs are `SECURITY DEFINER` and perform member/approval checks; before any new direct table access, audit effective grants and each function's ownership predicate. Hub must use the approved RPC surface, not broaden table access.
4. Some read-oriented helper RPCs showed `anon` execute privilege in Postgres metadata. Their function bodies must be checked for identity/approval gates before the Hub depends on them. Mutating Garden RPCs inspected are authenticated-only.
5. No backup/export was initiated because G1 made no change. Before any production migration, export the affected schema, function definitions, and Garden tables without credentials/passwords, record a recoverable migration version, and verify restore procedure.
6. The live static shell check is not a substitute for responsive, member-session, SSO, save-continuity, or game-action smoke tests.

## G1 gate

**Audit & Freeze: pass for read-only discovery.** The live architecture, current deployment, main game data ownership, server RPC boundary, current contract source, and safe no-change boundary are identified. No production state was changed.

**G2 is not started.** The dedicated repository is a mandatory prerequisite. The GitHub integration available here cannot create it, and creating an unrelated deployment/repository elsewhere would change the user's specified target. G2 preview and G3 data-parity gates therefore remain pending.

## Checkpoint G1

- **Branch:** none; read-only audit.
- **Commit:** source baseline `e10987e3b1ad2764f504e1b882c8f4617b5e627f`.
- **Files changed:** none in either GitHub repository; this report and `GAME_CONTRACTS.md` are audit artifacts.
- **Database migration:** none.
- **CI:** Web CI #1120 success; Vercel Production #1006 success, both for the baseline SHA.
- **Preview:** none for Game Hub; Study OS production shell verified HTTP 200.
- **Production:** current Study OS deployment READY; no change made.
- **Known issues/blockers:** Game Hub repository absent; repository creation capability unavailable in this session; no isolated test DB/test account verified; Garden/clinic authenticated playthrough not run.
- **Rollback:** no code or database mutation to roll back.
- **Next:** create `drngovothiennhan/hiutmc-game-hub` (empty repository; preserve current repositories), then continue G2 on a dedicated branch and preview. Do not deploy, migrate saves, or change old routes until preview and data-parity gates pass.


## G1 follow-up — repository creation confirmed

After the audit was recorded, the user confirmed that `drngovothiennhan/hiutmc-game-hub` had been created. The repository is separate from Study OS and was empty when inspected. A README-only bootstrap commit (`d5f88dcb387e22fcc3598c80506cd515b30d6839`) exists on `main`; implementation work is isolated on `g2/game-hub-shell`. No Study OS or production database changes have been made.

G2 implementation has passed local shell tests and static build. GitHub CI and a public preview are still pending; therefore the G2 gate is not yet passed. Local browser preview could not be verified in the remote browser environment. The shell's identity bootstrap uses the trusted `app_metadata.member_id` claim and deliberately avoids direct reads from `club_members`, whose inspected access path is server-function mediated. Member-session and CORS compatibility still require an actual Hub preview and approved SSO smoke test.


## Current checkpoint update — G2 preview and G3 readiness

This section supersedes the obsolete G1 follow-up above for current status. The earlier G1 findings remain as a historical read-only audit; the repository and deployment blockers described there have since changed.

### Checkpoint G2 preview

- **Branch:** `g2/game-hub-shell`
- **Commit verified:** `b6bb5779467fc9b3adc0b345653d5d119382e726`
- **Files changed in this checkpoint update:** this audit addendum only; no source or gameplay change.
- **Database migration:** none. Supabase inspection was read-only.
- **CI:** Game Hub CI succeeded for the verified commit: [run 36094118622](https://github.com/drngovothiennhan/hiutmc-game-hub/actions/runs/36094118622) and [run 36094116243](https://github.com/drngovothiennhan/hiutmc-game-hub/actions/runs/36094116243).
- **Cloudflare preview:** deployment succeeded in [run 36094116200](https://github.com/drngovothiennhan/hiutmc-game-hub/actions/runs/36094116200). The immutable deployment URL `https://983376a8.hiutmc-game-hub.pages.dev` was opened and rendered the G2 shell.
- **Preview caveat:** the branch alias `https://game-hub-shell.hiutmc-game-hub.pages.dev` returned a TLS 502 in the browser smoke. Use the immutable deployment URL for this checkpoint; the alias issue remains open.
- **Production/DNS:** no production deployment, custom domain, or DNS change.

### G2 gate still open

The shell, world map, navigation, session bootstrap code, and preview exist. Current game cards still launch the existing Study OS Garden and HIU Y Quán routes. The preview displays “Chưa có phiên đăng nhập” without a bridged member session. A real-member SSO/session smoke and responsive mobile/tablet smoke have not been verified. Therefore G2 is not marked passed and no gameplay migration is claimed.

### G3 source and contract preflight

The Study OS Garden entry is `HerbGardenGame.tsx` / `HerbGardenGameV7.tsx`; the current V7 care UI calls `herb_garden_state_v3`, `herb_garden_inventory_v3`, `herb_garden_visit_v2`, `herb_garden_seed_inventory_v1`, `herb_garden_reward_status_v1`, `herb_garden_wallet_v1`, and the existing plant/water/fertilize/harvest RPCs. The UI imports the Study OS React member type, Supabase client, icon package, and Garden styles; an exact extraction must preserve these dependencies and behavior rather than rewrite gameplay.

Read-only live definitions verified:

- `herb_garden_water_v4` and `herb_garden_fertilize_v4` resolve the member from the authenticated session, check approval, validate slot 1–9, and call `private.herb_garden_apply_care_v7`.
- The authoritative care function permits one water action in each of 12 six-hour growth slots and one fertilizer action in each of three 24-hour growth days. It rejects non-growing/expired plants, updates server counters, records events, and returns the resulting state.
- `herb_garden_harvest_v3` requires a mature, unexpired plant with at least 12 water and 3 fertilizer actions. It atomically adds one harvested herb, one same-species seed, 3 credits, increments plot harvest count, records an event, then evaluates sequential plot unlock.
- Existing Garden RPCs are SECURITY DEFINER and require an approved member. The Hub must call these server-owned routines and must not use direct table writes or client-supplied rewards.

### G3 safety gate

- Supabase development branch listing currently returns no branches.
- No approved isolated Garden test account has been verified.
- A transaction-rollback integration harness has not yet been established or run.
- No Garden gameplay action or row mutation was performed in the live Supabase project.
- **G3 gameplay extraction and data-parity QA have not started.** Do not exercise plant/care/harvest against a real member save until an isolated test identity/environment or a verified rollback harness is available.

### Rollback and next checkpoint

- **Rollback:** this documentation-only commit can be reverted; the prior Hub preview remains immutable. There are no Study OS, Supabase, production, or DNS changes to roll back.
- **Next:** close the G2 SSO/responsive smoke gap, establish a safe G3 integration test path, then extract the existing Garden runtime and dependencies into the Hub without changing its RPC or gameplay contract. Keep the existing Study OS runtime and saves untouched.
