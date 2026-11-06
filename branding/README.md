# Branding

Assets and settings that make the site match the Singapore Government Developer Portal look from the reference screenshot.

| File | Purpose |
| --- | --- |
| `logo-light.svg` | Header logo shown in **light** mode: purple-to-magenta "GT" badge + dark wordmark |
| `logo-dark.svg` | Same logo for **dark** mode (light wordmark) |
| `favicon.svg` | "GT" badge only |
| `customization.json` | Site customization payload (colours, font, header links, footer, AI assistant prompts) |
| `apply-branding.sh` | GET → merge → PUT the payload onto a site through the GitBook API |

## Palette

| Token | Light | Dark | Source |
| --- | --- | --- | --- |
| Primary (links, active nav) | `#2F5FE8` | `#8AA6FF` | Blue underline on the active "Docs" tab and the active sidebar item |
| Tint (surfaces) | `#F4F2FA` | `#1C1C2A` | Soft lavender page chrome; dark navy sidebar |
| Logo gradient | `#7C3AED` → `#C026D3` | same | The "GT" badge |
| Success (Validated badge) | `#16A34A` | `#4ADE80` | Green "Validated" pill |

Font: **Inter** for text, **IBM Plex Mono** for code. Sidebar is `filled` with `pill` list style to echo the dark, highlighted-item sidebar in the screenshot.

Logo and favicon URLs point at this repository's `main` branch on GitHub (raw), so they resolve as soon as the repo is public. If the repo stays private, upload the three SVGs under **Site → Customization → Logo / Favicon** in the GitBook UI instead.
