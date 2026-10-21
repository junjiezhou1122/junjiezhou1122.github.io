# Personal site agent guide

This repository owns Junjie Zhou's bilingual personal website. It uses Jekyll 4.4.1 with `jekyll-feed` and `jekyll-sitemap`. It no longer uses al-folio.

## Ownership

- `site/` is the complete publishable source. Keep tooling, tests, screenshots, audits, and authoring originals outside it.
- `site/_layouts` owns documents and articles. `site/_includes` owns shared contacts, writing rows, and the WeChat dialog.
- `site/_data/locales.yml` owns interface translations. `site/_data/socials.yml` owns contact destinations.
- `site/_posts` owns authored Markdown and metadata. Keep presentation scripts and styles out of post bodies.
- `site/_plugins/archives.rb` validates source metadata, resolves explicit translation pairs, and generates year, tag, and category archives from posts. It fails on duplicate routes or invalid metadata.
- `site/assets/css/site.css` owns styling. `site/assets/js/site.js` owns the mobile menu and native QR dialog. There is no asset build pipeline.

## Product contracts

Keep About and Blog as the only navigation sections, in English and Chinese. Keep the academic profile design, self-hosted Hanken Grotesk, white canvas, blue links, grey text, thin dividers, 1180px shell, and 720px article measure. Mobile places the portrait beside the name. Reading actions use the small blue SVG right arrow.

Humanive is a long-term direction. Preserve authored copy and intentional empty states. Home writing previews derive from the current locale's posts. A `translation_key` connects exactly two real counterparts. An article without a translation has no language alternative.

Keep explicit post permalinks and existing archive paths. Giscus uses strict pathname mapping and the repository/category identifiers in `_config.yml`. Changing these can detach existing discussions. WeChat fetches its QR only on activation and supports Escape, backdrop, close, and focus return. X is `https://x.com/junjiechou1122`.

## Work and checks

Create a branch before large refactors. Fix causes and fail with file/context on invalid input. Keep this guide aligned with architecture changes.

Use Ruby 3.3.5 and Node 24. Install with `bundle install` and `npm ci`. Run:

```sh
npm run lint:prettier
bundle exec jekyll build
npm run test:site
npx playwright install chromium webkit
npm run test:browser
```

The site serves the domain root with an empty `baseurl`. Do not pass `/al-folio`. Preview with `bundle exec jekyll serve` at `http://localhost:4000/`. The site workflow validates pull requests and deploys validated `main` builds to the existing `gh-pages` branch.
