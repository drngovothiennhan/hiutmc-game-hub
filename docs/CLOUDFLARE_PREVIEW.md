# Cloudflare Pages preview

The G2 shell preview is deployed to Cloudflare Pages using Wrangler Direct Upload. The workflow only runs for pushes to `g2/game-hub-shell` or a manual dispatch. It creates the `hiutmc-game-hub` Pages project if it does not exist, sets `main` as the production branch, and deploys the G2 build on the isolated `game-hub-shell` branch. This does not change DNS, attach a custom domain, or deploy the `main` branch.

## GitHub Actions secrets

Configure these repository-level Actions secrets in `drngovothiennhan/hiutmc-game-hub`:

- `CLOUDFLARE_API_TOKEN`: Cloudflare API token with Account → Cloudflare Pages → Edit permission.
- `CLOUDFLARE_ACCOUNT_ID`: the HIU TMC Cloudflare account ID.

The workflow never prints either value. If either secret is missing, the Pages deployment steps are skipped and the CI summary explains what is missing.

## Preview address

After a successful Cloudflare deploy, the branch preview is expected at:

`https://game-hub-shell.hiutmc-game-hub.pages.dev`

Confirm the actual deployment URL in the Cloudflare Pages deployment output before using it for browser QA. Cloudflare preview deployments are public by default; this shell contains no game-save reads or writes and uses only the public Supabase publishable key.

## Source

Cloudflare's official [Direct Upload CI guide](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/) documents Wrangler deployment, the two GitHub secrets, and the `Cloudflare Pages: Edit` token permission. Its [preview deployment documentation](https://developers.cloudflare.com/pages/configuration/preview-deployments/) describes branch previews and optional Cloudflare Access protection.
