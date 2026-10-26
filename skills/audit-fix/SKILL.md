---
name: audit-fix
description: Fix a failing dependency audit. Use when the CI audit step fails, or when asked for a dependencies/security fix.
---

# Deps audit fix

1. **Learn the repo first.** Find the CI step that runs the audit and copy it exactly: install command and flags, audit level, ignored advisories, and any guard scripts it runs first. Check the docs for an override policy and the commit/PR conventions. Treat those as the source of truth.
2. Get the advisories from the failing run's log.
3. Work in a fresh branch or worktree from the default branch. Install exactly as CI does.
4. Apply in-range fixes with the package manager's fix command (`bun audit fix`, `npm audit fix`, `pnpm audit --fix`).
5. Raise direct dependency floors to the patched version wherever the package is declared.
6. For anything still flagged:
   - Prefer upgrading the parent if a release with the fix exists.
   - Otherwise force the patched version (`overrides` for npm/bun, `pnpm.overrides`, yarn `resolutions`) with a minimum range, e.g. `^<patched>`. If the repo has an override policy or table, follow it.
   - Before forcing a new major onto a dependent, read its installed code to confirm it doesn't run the old major at runtime. Record why.
   - With no fix and below the CI audit level, leave it and mention it in the PR.
   - Never add a new ignore without the user's OK.
7. Verify with CI's exact audit command and guards, then the repo's lint, typecheck, test and build.
8. Commit and open the PR using the repo's conventions. List each package, its version and its advisory ID.
