# Personal site simplification

The user authorized removing the al-folio template constraint. Preserve the accepted academic visual style and all first-party writing and public entry points.

## Decision

Keep Jekyll, jekyll-feed and jekyll-sitemap. Own the document, navigation, article, archive and About templates directly. Move the publishable source under `site/`; tools, tests, audit records and screenshots at the repository root are then outside the publishing boundary. Retain the existing gh-pages deployment target and domain.

The alternative Node publisher would add hundreds of lines of Markdown, XML and date plumbing. It removes Ruby but does not improve this seven-post product enough to justify that ownership. Two independent sketches and a cross-judge preferred bare Jekyll.

Use one locale data table, one social-link table and explicit translation keys. Render navigation and language alternatives at build time. Keep the newest English-only essay without a fabricated translation. Remove presentation loaders from article content. CSS and JS are owned static assets, with no Tailwind, icon/font CDN, DOM localization patch, minifier or PurgeCSS stage.

Preserve the 21 currently generated first-party tag, category and year archive URLs through a small native Jekyll generator and one archive layout. Derive its membership from posts; do not hand-maintain 21 metadata files or keep the old archive gem. Retire the 35 template/demo pages. Keep the seven exact article URLs and Giscus pathname/repo/category identity.

Commit the existing generated responsive WebP portraits before removing ImageMagick. Preserve the original portrait as an authoring asset outside `site/`. Retain the QR image, font license and all authored Markdown. The Humanizer writing skill is first-party tooling; remove only the two obsolete al-folio setup/migration skills.

## Definition of done

- Seven post bodies match the baseline content hashes after removing only the old presentation-loader prefix. All explicit post permalinks, dates, locales, titles and descriptions survive.
- Two About pages, two Blog pages, seven posts, 404, 21 archives, feed, sitemap and robots render; no demo page or root tool/audit/output file publishes.
- Current profile, Humanive and writing text remain; accepted portrait/name and reading-arrow mobile layouts remain recognizable and responsive.
- GitHub, X, lazy WeChat QR, keyboard dialog behavior, language links and Giscus identity work without template JS. No invented translation link.
- Only required runtime gems remain; no al-folio, Tailwind, remote icon/font sheets, Python, ImageMagick, nbconvert or PurgeCSS in the build.
- One site workflow builds, checks source/output contracts and browser behavior, then deploys. Keep the existing CodeQL security workflow for JavaScript and Ruby. README and AGENTS describe actual ownership and commands.
- Independent final review passes before publication. Deployment and Pages complete; public English/Chinese and article routes are read back and exercised.

## Evidence boundary

The local `_site` contains ignored `output/` artifacts because the old root-source exclusion list is incomplete. This does not prove the clean GitHub runner published ignored local files. The dedicated `site/` source prevents that local-build risk structurally. Demo assets and routes are tracked and do build in clean checkouts.

## Phases

1. Capture source/body/route/rendered-content and visual baseline.
2. Implement the coupled migration in an isolated checkout, preserving content and assets first.
3. Verify clean dependency installation and production build; compare content, routes and browser behavior with the baseline.
4. Review code, publish boundary, dependency and CI simplification independently. Resolve accepted findings.
5. Publish with expected remote main SHA, verify deployment, Pages and public product.

## Throughput

Read-only audits and competing design sketches ran independently. One implementation owner receives the coupled layouts, data, build, tests and CI work in an exclusive worktree. The parent retains the unchanged baseline and owns independent review and publication.
