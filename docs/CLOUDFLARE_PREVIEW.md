# Cloudflare Pages previews

The preview workflow deploys branch builds to the isolated `hiutmc-game-hub` Cloudflare Pages project. The `main` branch remains the production branch; deploying a branch preview does not change production routing or DNS.

For Y Quán review, pushes to `g5/admin-y-quan-practice` deploy to the `admin-y-quan-practice` branch preview. This preview uses the same HIU TMC session and validates administrator access before showing the activity. See [Y Quán Admin Preview](Y_QUAN_ADMIN_PREVIEW.md) for the data boundary and lecturer review gate.

## GitHub Actions secrets

Configure these repository-level Actions secrets in `drngovothiennhan/hiutmc-game-hub`:

- `CLOUDFLARE_API_TOKEN`: Cloudflare API token with Account → Cloudflare Pages → Edit permission.
- `CLOUDFLARE_ACCOUNT_ID`: the HIU TMC Cloudflare account ID.

The workflow never prints either value. If either secret is missing, deployment fails before invoking Wrangler.

## Preview address

After the branch deployment succeeds, use the immutable deployment URL shown in the GitHub Actions summary. The Y Quán branch preview is expected at:

`https://admin-y-quan-practice.hiutmc-game-hub.pages.dev`

Cloudflare preview deployments are public by default; the game route itself checks the HIU TMC session and Admin role. Its case data is synthetic and contains no real patient information.

## Source

Cloudflare's official [Direct Upload CI guide](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/) documents Wrangler deployment, the two GitHub secrets, and the `Cloudflare Pages: Edit` token permission. Its [preview deployment documentation](https://developers.cloudflare.com/pages/configuration/preview-deployments/) describes branch previews and optional Cloudflare Access protection.
