# Junjie Zhou's website

English and Chinese personal pages and writing at [junjiezhou1122.github.io](https://junjiezhou1122.github.io).

## Preview and check

Use Ruby 3.3.5 and Node 24.

```sh
bundle install
npm ci
bundle exec jekyll serve
```

Open `http://localhost:4000/`. The site uses the domain root, with no baseurl override.

Run the checks before publishing:

```sh
npm run lint:prettier
bundle exec jekyll build
npm run test:site
npx playwright install chromium webkit
npm run test:browser
```

The checks discover public posts through Jekyll at the build time recorded in `_site/feed.xml`. Future posts and `published: false` drafts stay out of both output assertions and browser routes. The inventory helper lives under `test/` and publishes no manifest.

The site workflow runs these checks on pull requests and `main`. Successful `main` builds deploy `_site/` to `gh-pages`. CodeQL separately checks JavaScript and Ruby on changes and its weekly schedule.

## Edit the site

Write posts in `site/_posts/` with a title, date, description, explicit permalink, locale, tags, and categories. Use `en` or `zh-CN`. Keep a stable permalink after publication because Giscus discussions use the URL pathname. Give two translations the same `translation_key`; omit the key for an article without a translation.

`site/_data/locales.yml` contains interface text. `site/_data/socials.yml` contains contact links. Layouts and includes render the document, navigation, articles, and writing lists. One CSS file and one small JavaScript file own presentation and interactions. Jekyll generates feeds and sitemaps through their standard plugins. A local generator derives year, tag, and category archives from post metadata.

Only `site/` publishes. The original portrait is in `authoring/`; committed WebP sizes under `site/assets/img/` serve visitors. Audit records, tests, and output remain outside the source directory.

See [AGENTS.md](AGENTS.md) for the product and maintenance contracts. This site originated from [al-folio](https://github.com/alshedivat/al-folio), but owns its layouts and assets directly.
