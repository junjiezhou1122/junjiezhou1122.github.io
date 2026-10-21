# Site cleanup implementation

The implementation keeps Jekyll and the existing Markdown renderer, feed, and sitemap gems. `site/` contains all publishable input. The repository now owns its layouts, includes, locale/contact tables, archive generator, plain stylesheet, and menu/dialog script.

The Model the Domain principle led to explicit translation pairs and locale/contact data tables. It removed DOM localization and repeated destinations from authored pages. The Deslop pass removed obsolete gem compatibility selectors, theme hiding, loader scripts, unused demos, and template build stages.

Seven article bodies match the pre-migration hashes in `site-cleanup-contracts.json` when normalized as `body.trim() + newline`. Titles, descriptions, dates, tags, categories, locales, and literal article permalinks survive. The two Feed articles continue to derive their dates from their original filenames. `site-cleanup-archives.json` records the 21 old archive routes and memberships for the parent migration audit. These body hashes are migration evidence, not a permanent CI freeze on writing.

The source/output tests derive current articles and archive memberships from source. They check rendered article text, comments, real translation alternatives, locale counts, canonical/Atom/sitemap output, local resources and fragments, and the full published-file set. Temporary builds reject invalid locales, route duplicates, archive collisions, and orphan translation keys; a new tag automatically creates its archive. Chromium and WebKit exercise all core/article routes on mobile and desktop, loaded font faces, overflow, arrows, both menu Escape paths, and lazy QR fetching with modal keyboard/backdrop/focus behavior.

Local browser tests stub the Giscus remote script to avoid making network availability a local UI test prerequisite. They preserve and check the real integration attributes in generated HTML. Actual remote Giscus loading, final independent review, CI, and production deployment remain the parent's verification responsibilities.

The old CodeQL triggers, weekly schedule, JavaScript and Ruby coverage remain. Only unused matrix/manual-build boilerplate was removed. The site workflow validates changes and publishes validated main artifacts to the existing gh-pages branch. No push or deployment occurred from this worktree.
