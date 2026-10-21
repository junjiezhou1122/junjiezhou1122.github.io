# Bare Jekyll architecture proposal

Keep Jekyll and replace the al-folio runtime with site-owned HTML, CSS, and one WeChat dialog script. The current seven posts use ordinary Markdown. This preserves the academic visual design without a browser framework, CSS pipeline, ImageMagick, Python, or template gems. This proposal is grounded in `/tmp/site-contract-audit.md`, `/tmp/site-bloat-audit.md`, and the current configuration, pages, posts, and deployment workflow.

## File ownership

Use a dedicated `site/` source directory. Root tooling, audit files, screenshots, and test artifacts cannot publish merely because someone forgets an `exclude` entry.

```text
_config.yml
Gemfile, Gemfile.lock
package.json, package-lock.json
site/
  _layouts/default.html
  _layouts/about.html
  _layouts/blog.html
  _layouts/post.html
  _includes/head.html
  _includes/navigation.html
  _includes/post-list.html
  _includes/social-links.html
  _includes/wechat-dialog.html
  _includes/giscus.html
  _data/locales.yml
  _data/socials.yml
  _posts/                         # the same seven Markdown articles
  index.md, zh/index.md
  blog/index.md, zh/blog/index.md
  404.html, robots.txt
  assets/css/site.css
  assets/js/wechat-dialog.js
  assets/fonts/HankenGrotesk-Variable.ttf
  assets/fonts/HankenGrotesk-OFL.txt
  assets/img/junjie-profile-480.webp
  assets/img/junjie-profile-800.webp
  assets/img/wechat-qr.JPG
test/site-contract.rb
test/browser.spec.js
.github/workflows/site.yml
README.md, AGENTS.md, LICENSE
```

`_config.yml` sets `source: site`, the production URL, empty baseurl, explicit post defaults, and only `jekyll-feed` and `jekyll-sitemap` plugins. Use a locked supported Jekyll version. Nokogiri can be a development-only dependency for HTML assertions. Keep Playwright and Prettier as development tooling. Remove unused direct pixel comparison dependencies unless retained screenshot tests consume them.

`default.html` owns document, head, navigation, main landmark, and footer. `about.html` owns profile/contact positioning around the biography content. `blog.html` owns the localized archive title and complete post list. `post.html` owns title, date, reading time, prose, and Giscus. `post-list.html` accepts posts and an optional limit, so home and archive share row markup. Avoid generic component registries and layout JavaScript.

## Content and locale contracts

Page front matter names `layout`, `lang`, `permalink`, `title`, `description`, and `translation_key`. Posts retain explicit permalinks, existing date/timezone, descriptions, tags, and all article prose. Give paired articles the same `translation_key`. The EN-only article has its own key and no Chinese peer.

`locales.yml` is keyed by `en` and `zh-CN`. Each entry owns About/Blog labels and URLs, date format, reading-time labels, archive title, section labels, and Giscus language. `socials.yml` owns GitHub and X URLs and the WeChat dialog target once. Localized labels can live in the locale data. Templates render correct labels and active links directly. Delete `site-language.js`, body-level stylesheet links, and embedded language-switch markup from all content.

Resolve alternate language links by matching `translation_key` across pages/posts. Render no alternate link when none exists. Add `hreflang` only for real counterparts. Select posts by exact language. Home shows three per language, archives show four EN and three ZH. Never manufacture a Chinese version of the latest English essay.

The seven canonical article URLs remain unchanged. Preserve `/`, `/zh/`, `/blog/`, `/zh/blog/`, `/404.html`, `/feed.xml`, and `/sitemap.xml`. The source move changes no public URL. Preserve decoded `P(you | your history)` and the intentional no-table formatting.

## Assets and interaction

Write one readable CSS file around tokens, document base, navigation, profile, post rows, prose, dialog, and responsive rules. Preserve the white canvas, Hanken font, Google blue links, 1180px shell, 720px articles, portrait/sidebar layout, and small blue horizontal reading arrows. Delete Bootstrap/Tailwind compatibility selectors and hidden dark-mode rules. Use small inline SVGs or text for contact icons. No icon CDN.

Commit generated portrait WebP files before removing ImageMagick. Keep responsive `srcset`, dimensions, and eager priority for the portrait. Keep the QR image unfetched until dialog activation. Native dialog behavior must retain close button, backdrop close, Esc, and trigger focus restoration. Load this script only on About pages.

Giscus keeps repo IDs, category IDs, strict pathname mapping, reactions, and input position exactly. Serve a static client script with light theme and page-language attributes inside `#giscus_thread`. All seven posts opt in through post defaults. Keep Giscus outside article feed content.

## Archive decision and deletion boundary

Delete all demo collections, assets, plugin infrastructure, and template documentation. Remove stale tags/year links from article metadata.

Recommend preserving the 21 existing real blog archive URLs with explicit thin pages using one `archive.html` layout and ordinary Liquid filters. This avoids silently breaking published entry points without retaining `jekyll-archives-v2`. These pages list only first-party posts and need no navigation prominence. Deleting these routes is a separate product decision, not an automatic consequence of removing a gem. Template demo routes can deliberately become 404s.

## Verification and delivery

One CI workflow installs locked Ruby and Node dependencies, checks formatting, performs a clean production build, validates generated HTML and local links, and runs desktop/mobile browser tests. Deploy only after successful checks on the default branch. Preserve the existing `gh-pages` publication method unless intentionally migrating Pages configuration.

Contract tests verify exact article routes, article text preservation, locale counts and alternates, canonical/feed/sitemap output, Giscus attributes, local asset references, and an allowlist of published files. Browser tests cover both About pages, both archives, one article per language, EN-only alternate absence, 390px overflow, arrow appearance, and QR lazy loading plus keyboard/focus behavior. A clean build must contain no demo route, test artifact, dependency file, or remote typography/icon request. After deployment, verify cache-busted public routes and actual comments loading.
