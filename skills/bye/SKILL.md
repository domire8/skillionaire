---
name: bye
description: Close out this session before the user deletes it - what it did, whether it is done, whether its worktree and branch can go, and what knowledge would be lost. Use when the user says /bye or asks "can I delete this session", "is everything done", "can the worktree go".
---

# Bye

Answer from evidence, not memory. Git, GitHub and the filesystem are the
record; use the transcript only for what they don't hold.

**Ask first.** Do not delete, remove or clean up anything (files, worktrees,
branches, stashes), and do not create issues, comments, memories or files,
until the user confirms that specific action.

Gather everything in one shell call: status, ignored files (below), commits
not on origin, stashes, worktrees, and the branch's PR (skip `gh` on the
default branch). With squash merges, judge by the PR: merged and local tip
is (an ancestor of) `headRefOid` means nothing is lost.

In a worktree, ignored files die with it and plain `git status` hides them.
List them (`git ls-files -oi --exclude-standard --directory`), drop
regenerable ones (dependencies, build and cache output), and check whether
each remaining path also exists in the main checkout; compare `.env*` by
path only, never read them. Anything ignored that exists only in this
worktree (notes, plans, scratch output, local config) goes under Would be
lost and makes the verdict Not yet.

Reply verdict first, then only sections with content:

- **Verdict:** Safe to delete / Not yet, with the reason in one line.
- **Did:** two or three sentences. Point to the record (branch, PR, commit
  range like "3 commits on main, pushed"), never list commits one by one.
  Name a decision only if its why is not already in a commit or PR.
- **Open:** blockers only: unpushed or unmerged work, CI, reviews, running
  sessions, unverified claims.
- **Would be lost:** items that exist only in the transcript, scratchpad or
  ignored worktree files, each with a suggested home (memory, PR/issue
  comment, doc, copy to the main checkout).
- **Cleanup:** exact commands, only if there is something to clean.

When everything is clean, keep the whole answer under ~8 lines.
