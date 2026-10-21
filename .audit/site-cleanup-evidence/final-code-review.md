# Final independent review

Verdict: PASS. No actionable correctness or landing-blocker findings in this follow-up.

Reviewed HEAD `d382a995546110c27ac84f0636bdf191a91df429` against baseline `b714e17b36a801e6c0693f5d1793c1c661bc71fa`. This follow-up specifically rechecks the only P2 found at `d41b2ed7ada00906df67e41a1b86d414a84251f0`, the public-post inventory fix, and the deployment pipeline. It reads the earlier full review as prior evidence and does not claim to repeat its full migration audit.

## Public inventory fix

`test/public_posts.rb` reconstructs a Jekyll site with the configured source and the build timestamp read from the generated Atom feed. Installed jekyll-feed 0.17.0 emits `site.time` as that top-level timestamp. Installed Jekyll 4.4.1 filters its post collection through Publisher when reading, and `Document#write?` applies collection/publication eligibility. Consequently the helper follows the same native future and `published: false` rules at the build's effective time. It gets URLs from parsed Jekyll documents, removing the browser's fragile raw YAML regex and its quoted-permalink bug.

The inventory only supplies source paths and effective URLs. The Ruby checks still parse authored front matter and body independently, compare generated article content/title/locales/Giscus, derive archive and locale membership expectations, check feed and sitemap membership, and enforce the complete published-file set. The browser spec consumes the helper's JSON output using execFileSync, which propagates errors rather than silently skipping routes. No public test manifest or runtime dependency was added.

The new temporary build fixture fixes build time to 2024 while including 2025 and 2099 scheduled posts, an unpublished 2020 post, and a quoted 2020 public permalink. It passes the complete source/output assertions against that fixture and checks the browser inventory plus absence of hidden routes in HTML/XML, feeds, and archives. The 2025 post is already in the past at review time, so this exercises build-time reconstruction rather than accidentally passing because of today's wall clock.

## Independent verification

An exact `git archive d382a99` was extracted to `/var/folders/nf/p_gz13xx08n82_nn23sptk9r0000gn/T/site-final-review-i4gjrlky`. No primary source, build output, dependency tree, server, or port 4187 was mutated.

- Ruby 3.3.5 production Jekyll build passed: 7 posts, 21 archives, 12 authored routes.
- `bundle exec ruby test/site_test.rb` passed: 931 ordinary output assertions and 949 total assertions including negative/publication fixtures.
- A deliberate generated-title corruption in that temporary copy caused the source/output suite to fail with `Title changed at /blog/2026/the-network-comes-later/`, then the original generated file was restored. The inventory change therefore preserves a meaningful independent output check.
- Playwright `test --list` under Node 24 and Ruby 3.3.5 successfully executed the changed browser inventory path and discovered 48 Chromium/WebKit tests with clean public routes. This reviewer did not run browsers because the parent owns the primary full matrix.
- `git diff --check b714e17..d382a99` passed.

## Pipeline review and evidence limits

`.github/workflows/site.yml` checks out the same revision, sets Ruby 3.3.5 and Node 24, installs locked dependencies, runs formatting, a production build, source/output checks, and Chromium/WebKit before uploading `_site`. The deploy job requires successful validation, consumes that same uploaded artifact, grants contents write only to deployment, targets existing `gh-pages`, and excludes pull-request events. The lockfile includes x86_64-linux platforms for native gems. No static workflow or package-script blocker was found. CodeQL still covers JavaScript and Ruby on main/PR changes and its weekly schedule.

Actual hosted CI, branch protection, Pages settings, public cache behavior, and real Giscus iframe delivery are not established by static pipeline review or local tests; the parent retains responsibility for those release checks. This is an evidence boundary, not a newly found defect.
