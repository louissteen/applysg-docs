# applysg-docs

Source for the **ApplySG** documentation site on the Singapore Government Developer Portal (GitBook demo, dummy data).

Each top-level folder is one GitBook space, mapped to one section of the site by `gitbook-docs.yaml` (site-wide Git Sync):

| Folder | Section | What it covers |
|---|---|---|
| `user-guide/` | User Guide | Setting up and operating form-based workflows (agency officers) |
| `integrator-guide/` | Integrator Guide | Webhooks, embedding, SSO, exports (agency developers) |
| `api-specs/` | API Specs | REST reference from `api-specs/openapi/applysg-api.yaml` |
| `advanced-capabilities/` | Advanced Capabilities | Conditional logic, automation, analytics, multi-agency |

`branding/` holds the logo and favicon assets plus the site customization payload (`customization.json`) and a script to apply it through the GitBook API once the site exists.

See `HANDOFF.md` for the Git Sync and branding steps.
