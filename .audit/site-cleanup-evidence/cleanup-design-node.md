# Candidate B: a Node-owned static publisher

Grounding: `/tmp/site-contract-audit.md`, current `_posts`, `_pages/about.md`, `Gemfile`, `package.json`, and `.github/workflows/deploy.yml`. `/tmp/site-bloat-audit.md` was not yet available when this sketch was written. No installation, build, repository edit, or public mutation performed.

## Distinct architecture

Use Node 24 as the only build runtime, Markdown content as the authoring interface, a deliberately small static generator, and native HTML/CSS/browser APIs. No React, client router, hydration, Tailwind, bundler, or plugin framework. The generator writes a complete `_site` from an explicit input allowlist; it never copies the repository root. This removes the current accidental publishing of demo collections and `output/` artifacts structurally.

```text
content/posts/*.md        Seven existing articles, metadata retained
content/about/{en,zh}.md  Biography and Humanive copy
site/config.json         Identity, locale strings, contacts, Giscus
site/templates.mjs       HTML shell, About, archive, post, dialog
scripts/build.mjs        Validate -> parse -> render -> write
public/assets/           One CSS, WeChat JS, font, portrait WebP, QR
scripts/verify.mjs        Output routes, metadata, links, comment contract
```

Use two direct production dependencies: a maintained Markdown renderer and a YAML parser (`markdown-it` + `yaml` are candidates, not installed or version-verified). Node owns filesystem operations, URL handling, XML escaping, date formatting, and output assembly. Keep Playwright/Prettier as development tools. Eleventy is the alternative if future collections or authoring rules outgrow this boundary: it saves generator code but buys a larger package surface for eleven primary HTML routes. Do not implement an Eleventy-shaped plugin system ourselves.

Target own-code budget, not measured implementation: generator 180–250 lines; HTML renderers 160–220; metadata/feed/sitemap helpers 60–100; browser JS 40–60; output-contract check 100–150. Approximately 550–780 JS lines plus one 250–350-line CSS file. This is understandable code, but it is new owned infrastructure.

## Exact durable contracts

Retain `/`, `/zh/`, `/blog/`, `/zh/blog/`, `/404.html`, `/feed.xml`, `/sitemap.xml`, and `/robots.txt`. Retain these literal post permalinks; no slug inference:

- `/blog/2026/no-history-no-personal-ai/`
- `/zh/blog/2026/no-history-no-personal-ai/`
- `/blog/2026/the-network-comes-later/`
- `/zh/blog/2026/the-network-comes-later/`
- `/blog/2026/the-feed-is-not-the-world/`
- `/zh/blog/2026/the-feed-is-not-the-world/`
- `/blog/2026/who-defines-good-for-an-ai-agent/`

All seven posts keep Giscus `data-mapping="pathname"`, `data-strict="1"`, repo `junjiezhou1122/junjiezhou1122.github.io`, repo ID `R_kgDOUDvAag`, category `Announcements`, category ID `DIC_kwDOUDvAas4DEU1q`, reactions `1`, emit-metadata `0`, input-position `bottom`, and `#giscus_thread`. Query strings used for release checks must not become discussion identity. Use the actual pathname by preserving route spelling and trailing slashes; no new term mapping. EN-only article must not gain a fabricated ZH equivalent.

Require title, description, date, lang, and explicit unique permalink at build time. Invalid YAML, unknown locale, duplicate output paths, missing required assets, or remaining Liquid must throw with filename/context. Transfer legitimate bilingual equivalence into explicit metadata; render nav at build time. Remove the repeated CSS/script/Liquid loader snippets from all articles; do not add a general Liquid interpreter or silently strip arbitrary template expressions.

Render HTML lang, title, description, author, viewport, canonical production URL; actual translation pairs alone receive hreflang. Atom contains all seven articles with canonical links, stable URL-derived IDs, ISO timestamps, per-entry language, and escaped article HTML without UI loaders. Sitemap lists only intended public pages; robots points to production sitemap. Explicitly decide whether existing generated tag/year/category archives survive as small pages or redirects, and verify no published internal links break.

Pre-generate and commit the current 480/800 portrait WebP files before deleting ImageMagick: their source equivalents currently exist only in `_site`. Preserve font license, lazy WeChat QR load, native dialog keyboard/focus behavior, current X handle, language-filtered recent notes, and the accepted mobile arrow treatment.

## Deployment and validation

Keep the existing publishing model: build `_site`, then `JamesIves/github-pages-deploy-action@v4` publishes to `gh-pages`. Preserve the repository's Pages source configuration and public domain. Workflow becomes checkout -> Node 24 -> `npm ci` -> build -> output contract verification -> existing branch deployment action. Remove Ruby, Python, ImageMagick, nbconvert, PurgeCSS, and YAML mutation. Add package/lock/template paths to workflow triggers.

The gate is a clean output diff plus browser behavior: route manifest; seven article text checks including `P(you | your history)` without accidental tables; local links; Atom/XML parsing; Giscus attributes; English/Chinese mobile and desktop layout; working WeChat dialog; no runtime errors or unwanted requests. Deploy only after these pass, then inspect public Pages terminal success and fresh canonical routes.

## Recommendation

**Prefer bare Jekyll for this cleanup.** The user removed the template constraint, not necessarily the static generator. Removing al-folio and unused plugins yields nearly the same output/runtime simplicity while retaining a proven Markdown/Liquid/date/feed pipeline. Node removes the Ruby toolchain, but requires hundreds of new lines, a second Markdown parser's behavior audit, and owned feed/sitemap correctness. Choose Node only if a single Node toolchain is itself an explicit product requirement or the bare-Jekyll spike exposes a real blocker. Either candidate should remove template machinery, DOM-rewriting localization, demo publishing, and duplicated presentation in content.
