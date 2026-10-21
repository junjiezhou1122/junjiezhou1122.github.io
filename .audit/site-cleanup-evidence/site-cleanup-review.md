# Independent cleanup review

Verdict FAIL pending one P2 authoring fix.

Reviewed HEAD `d41b2ed7ada00906df67e41a1b86d414a84251f0` against baseline `b714e17b36a801e6c0693f5d1793c1c661bc71fa`.

## Finding

P2. Valid unpublished or future-dated source posts break the new required release checks.

`test/site_test.rb:38-47` reads every Markdown file under `_posts` and immediately requires a corresponding generated page. `test/browser/site.spec.js:3-7` likewise enumerates every source file. Jekyll correctly excludes `published: false` posts and future-dated posts by default. Therefore normal authoring can produce a valid successful build that these checks reject, preventing unrelated releases until the unpublished file is removed or prematurely published.

I reproduced both cases in temporary copies outside the primary checkout with `/tmp/review-future-post.rb`, run as `mise exec ruby@3.3.5 -- bundle exec ruby /tmp/review-future-post.rb`. A new valid English-only post dated `2099-01-01` builds with the expected seven public posts, then the site test exits 1 with `Missing page /blog/review-future/`. A post dated `2026-01-01` with `published: false` produces the same failure at `/blog/review-unpublished/`.

Derive the effective public-post inventory with Jekyll's publication rules and the same effective time as the built artifact. Reuse that inventory for browser routes. Keep the independently parsed content, membership and output assertions. Add temporary fixtures proving future and unpublished posts stay out of HTML, feed, sitemap and archive memberships while the full checks pass. The browser's raw front-matter regex also treats YAML quotes as URL characters, so using the parsed inventory will remove that second fragile parsing path.

## Other reviewed areas

The runtime is materially smaller and follows the requested ownership. `site/` structurally isolates publication from tooling and authoring originals. The configured source, generated pages and full output-file assertion enforce this boundary. Layouts render locale navigation and actual translation alternatives on the server. The English-only essay has no fabricated counterpart. The archive generator derives memberships from live posts and rejects authored-route collisions with file context. Route-safe tag/category slugs match existing public routes. The paired-translation guard is explicit rather than a hidden fallback.

Giscus retains the baseline repository/category identifiers, strict pathname mapping and existing article URLs. The native QR dialog loads its image only on activation and restores focus. Local CSS, fonts, portrait WebPs and QR are referenced by the owned templates. The font license and original portrait remain tracked outside/inside the intended boundaries respectively. No exception-swallowing or speculative fallback logic was found.

The CI build uses pinned Ruby, locked Ruby/Node dependency trees, a production Jekyll build, source/output checks, and Chromium/WebKit before artifact upload. Deployment consumes that validated artifact and targets the existing `gh-pages` branch. PRs cannot enter the deploy job. CodeQL retains JavaScript and Ruby, its `main`/PR triggers, and the weekly schedule.

The source/output tests read actual rendered HTML, resources, feed and sitemap and include negative builds. They are not merely function-return mirrors. Migration body hashes and the 21 baseline archive memberships are intentionally separate from the ongoing tests. The parent independently verifies those baseline comparisons and runs the main browser matrix, so this report does not claim those tests as my own executions. Giscus is stubbed by the local browser suite; the parent must verify its real public iframe after deployment.

## No-comments and deslop perspective

Manual review found no unnecessary narration comments, suppressed exceptions, type bypasses or compatibility layers worth deleting. The retained Hanken Grotesk OFL license is necessary external-license text. Product constraints and external Giscus identity are recorded in AGENTS rather than unexplained source comments. No nested reviewer or source edits were made because the assigned scope explicitly prohibited them. The required change is in test publication inventory, not the runtime.
