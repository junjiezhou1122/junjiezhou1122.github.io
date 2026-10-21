# Site cleanup evidence

This is a one-time migration record, outside the publishable `site/` source. Normal site checks derive expectations from current content; the historical hashes here do not freeze future writing.

The baseline is deployed commit `b714e17b36a801e6c0693f5d1793c1c661bc71fa`. The two independent design sketches and architecture judgment explain retaining bare Jekyll rather than owning a new publisher. `inventory-comparison.json` records clean production artifacts, the 35 removed demo URLs, dependency/workflow counts, and public-asset bytes. The old build includes its deployment PurgeCSS stage. Artifact bytes are not page transfer bytes or reclaimed Git history.

`before-desktop.png`/`after-desktop.png` use 1280px viewports; `before-mobile.png`/`after-mobile.png` use 390px. Visual readback retained the white canvas, Hanken Grotesk, blue actions, 46px/34px primary headings, left portrait/name composition, and 720px desktop article width. The source no longer creates empty loader paragraphs, and owned line contact icons replace the icon-font symbols. Navigation/footer now render directly. These deliberate small differences are not a pixel-identity claim. `visual-readback.json` records computed values and no horizontal overflow on the sampled routes.

Root separately verified all seven historical Markdown bodies/metadata and all 21 archive memberships. Re-run that migration-only check after a production build with Ruby 3.3.5:

```sh
bundle exec ruby .audit/site-cleanup-evidence/verify-migration.rb
```

It reads the baseline Git object and the committed `.audit/site-cleanup-contracts.json` and `.audit/site-cleanup-archives.json`. A shallow checkout may need to fetch the baseline commit first.

The initial independent review found a public-post inventory defect. The final code review confirms that future/unpublished articles and quoted permalinks are now handled through Jekyll at the artifact's build time. A later test-only refinement preserves intentional empty blogs and replaces fixture dependence on real essays with deterministic temporary articles. Current root checks pass 953 assertions and 48 Chromium/WebKit cases; UI screenshots and full local logs are also retained in ignored `output/`.

CodeQL remains enabled for Ruby and JavaScript. Site CI uses an explicitly supported Ubuntu 24.04 browser image, Ruby 3.3.5 and Node 24, validates before deployment, and deploys the same checked artifact to `gh-pages`.

Browser regression tests stub the remote Giscus client. The generated identity attributes are checked, but actual widget delivery and public CDN behavior require the post-deployment live pass. The release outcome is now recorded in `release.json`: Site validation/deployment and Pages succeeded, all retained routes and expected retired/private 404s were checked, and the real English/Chinese Giscus composers loaded without JavaScript errors.

The separate audit reviewer flagged stale checklists, temporary evidence paths, and missing before/after visual evidence during the ongoing run. This folder and the updated decision trail resolve those evidence gaps. Review sessions are independent of implementation; no cross-provider model-voting claim is made.
