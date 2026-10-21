# Architecture judgment

**Base: bare Jekyll with `source: site`.** The cleanup should remove al-folio, its unused feature gems, demo content, compatibility CSS, runtime localization, and template maintenance workflows. Keeping the existing Markdown/Liquid engine is the smallest ownership change that achieves the user's goal. Node's dependency count is lower, but its proposed 550–780 owned JavaScript lines introduce a publisher, feed/sitemap implementation, and parser migration that the product does not need.

| Criterion | Bare Jekyll | Custom Node |
|---|---|---|
| Content / Giscus identity | Existing Markdown parser and literal permalinks minimize changes | Achievable, but renderer/date/escaping differences require a broader migration audit |
| Publication isolation | `source: site` structurally separates source from repository tooling | Explicit input allowlist provides equally good isolation |
| Own code / dependencies | Existing engine plus feed/sitemap; modest Liquid and one tiny generator | Fewer packages, substantially more owned publishing code |
| Authoring / CI | Familiar front matter and Markdown; Ruby + Node dev tools | One runtime, but custom build semantics need maintenance |
| Migration risk | Lower; remove layers around the existing content pipeline | Higher; replace the pipeline and its surrounding layers simultaneously |

## Archive routes

**Preserve the 21 first-party year/tag/category routes with a tiny native Jekyll generator and one archive layout.** Twenty-one handwritten front-matter files duplicate metadata that already lives in posts and become stale on the next new tag or year. Redirects retain URL reachability but discard the useful filtered archive behavior. Removing these published routes unnecessarily expands this cleanup's product scope.

Put the generator in `site/_plugins/archives.rb`; use Jekyll's normal page API, not a new plugin dependency. Group posts by year, tag, and category, use the existing route spelling/slug convention, and assign posts and title metadata to `archive.html`. Keep its responsibility strictly grouping and page creation. Locale-aware headings can derive from an explicit archive language rule; the existing shared English namespace may legitimately list bilingual entries. Do not silently change route namespaces to improve localization.

Capture the exact existing 21-route manifest and per-route post membership before replacement. Verify the generated routes against that manifest, including trailing slashes and slug punctuation. Fail on collisions with explicit pages or another generated route. Also test that a new tag creates a route automatically; this verifies the reason to own the generator instead of handwritten pages.

## Grafts and gates

Take Node's strict input-validation ideas: require valid locale and explicit unique article permalink; report filename/context for duplicate paths, missing assets, and invalid metadata. Keep this validation small and near the build/test boundary; do not build a parallel content framework.

Retain Jekyll's feed and sitemap gems, exact article paths, Giscus pathname mapping and identity attributes, the seven article bodies, current X handle, and real translation pairing. Commit portrait WebPs before removing ImageMagick. Replace DOM localization with rendered navigation, use one CSS file, and retain only the native WeChat dialog script.

Build from a clean destination, verify the entire public file manifest and all local links, compare normalized article text, and check canonical/alternate/feed/comment output. Browser verification must cover both languages, mobile layout, the accepted arrows, dialog keyboard behavior, and live Giscus loading. Preserve the existing `gh-pages` deployment mechanism and publish only after the simplified CI gates pass. Rewrite README/AGENTS for the final site architecture; old gem-ownership rules must not survive as obsolete constraints.
