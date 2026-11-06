# ApplySG docs — handoff

Repo: `louissteen/applysg-docs` (branch `main`). One repository, four spaces, site structure declared in `gitbook-docs.yaml`. Dummy data throughout.

## 1. Connect the repo with site-wide Git Sync (UI only)

1. In GitBook, open (or create) the target site in your org, then open **Git Sync** from the site sidebar.
2. Connect **GitHub** with the account that can see `louissteen/applysg-docs`. If the repo is not listed, install or configure the GitBook GitHub app at <https://github.com/apps/gitbook-com> and grant it access to this repo.
3. **Source repository**: `louissteen/applysg-docs`, branch `main`.
4. **Project directory**: leave empty (`gitbook-docs.yaml` is at the repo root).
5. **Initial sync direction**: **GitHub → GitBook**. Do not swap it; the repo is the source of truth and the site is empty.
6. Under **Content mapping**, GitBook reads `gitbook-docs.yaml` and lists the four spaces/sections. Confirm each one maps to its directory:

   | Section | Space key | Directory |
   | --- | --- | --- |
   | User Guide (default) | `space-user-guide` | `./user-guide` |
   | Integrator Guide | `space-integrator-guide` | `./integrator-guide` |
   | API Specs | `space-api-specs` | `./api-specs` |
   | Advanced Capabilities | `space-advanced-capabilities` | `./advanced-capabilities` |

7. Click **Sync** and wait for the import.

**After the first sync, check for the initialization race.** When several spaces are created in one go, each new space may export an empty revision back to the repo and overwrite that directory's `README.md` (`# Page`) or truncate its `SUMMARY.md`. Run:

```bash
git pull && git log --oneline | grep -i "Export content from"
git diff HEAD~5 -- '*/README.md' '*/SUMMARY.md'
```

If anything was clobbered, restore the files from the previous commit and push again.

## 2. Register the OpenAPI spec

`api-specs/SUMMARY.md` auto-generates the endpoint pages from a spec registered in the org under the slug **`applysg-api`**. GitBook needs that registration once:

* **UI**: Org → **API references** (or Site → OpenAPI specs) → **Add spec** → upload `api-specs/openapi/applysg-api.yaml`, slug `applysg-api`. Or point it at the raw GitHub URL once the repo is public: `https://raw.githubusercontent.com/louissteen/applysg-docs/main/api-specs/openapi/applysg-api.yaml`.
* **API**: `POST /v1/orgs/{orgId}/openapi/applysg-api` with `{"source": {"url": "<raw url>"}}` or a text upload.

Until the spec is registered, the API Specs space renders its five prose pages and shows an empty "ApplySG API" group.

## 3. Resolve cross-space links

Pages link to the other spaces with placeholders (`XSPACE_USER_GUIDE`, `XSPACE_INTEGRATOR`, `XSPACE_API`, `XSPACE_ADVANCED`). After the first sync, read the real space IDs from `GET /v1/orgs/{orgId}/sites/{siteId}/structure` (walk the tree for `object == "site-space"`) and run:

```bash
./scripts/resolve-xspace.sh <userGuideSpaceId> <integratorSpaceId> <apiSpaceId> <advancedSpaceId>
git commit -am "Resolve cross-space links" && git push
```

## 4. Apply branding

```bash
export GITBOOK_TOKEN=$(op read "op://…")
./branding/apply-branding.sh <orgId> <siteId>
```

This merges `branding/customization.json` (primary blue `#2F5FE8`, lavender tint, Inter + IBM Plex Mono, filled sidebar, header links Products / Docs / Events / About, footer groups, AI assistant prompts) over the site's current customization. Logo and favicon URLs point at the raw files in this repo; if the repo stays private, upload the SVGs in `branding/` through **Site → Customization** instead.

## 5. Publish

Site → **Publish** → public (or in-collection / authenticated for the demo audience). Then spot-check:

* `User Guide → Get Started` renders the stepper and the green "Validated" hint.
* `API Specs → ApplySG API` shows generated operation pages with a Test it runner.
* `Integrator Guide → Changelog` and `API Specs → API changelog` render the Updates timeline with tag chips.
* Cross-space links resolve (no editor login page).

## Working alongside UI edits

Once Git Sync is live, UI edits land on `main` as GitBook-authored commits. Always `git pull` before pushing from this folder; nothing in this repo is generated, so there is no script that can overwrite hand edits.
