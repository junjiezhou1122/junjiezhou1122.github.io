# Site simplification

- [x] Read the Principles section of poteto-mode.
- [x] Phase A: Frame. Preserve first-party content, routes, language behavior, visual direction and comments; remove unused template infrastructure.
- [x] Phase B: Design the workflow.
- [x] Capture baseline route/content/asset and browser evidence before source changes.
- [x] Compare two structural designs and record selected ownership and contracts.
- [x] Delegate the coupled migration in one exclusive worktree.
- [x] Verify a clean build, published-file boundary, stable post text and routes, then desktop/mobile functionality.
- [x] Independent review of final diff and production artifact; fix accepted defects.
- [ ] Publish through expected-SHA GitHub update, observe deployment and Pages, verify public routes.
- [x] Phase D: Keep the audit trail.
- [ ] Phase E: Verify and hand back.

Throughput checkpoint:
- Blocking first steps: source/dependency/content audits and baseline before migration.
- Independent workstreams: read-only audits/designs; implementation is coupled.
- Shared mutable state: implementation worker gets its own checkout; root keeps baseline checkout unchanged while it works.
- Smallest safe decomposition: one implementation owner for layouts/config/assets/tests/CI avoids incompatible in-flight systems.
