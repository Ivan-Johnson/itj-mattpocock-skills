# Evidence: docket native code review spec (#82)

One instance where `/to-spec` left contradictions, and mechanisms the code
can't support, for implementers to find. Feeds the `/to-spec` steps 1 and 3
item in the map (`../README.md`).

## Context

* Date: 2026-11-22 (retro of the `/implement-spec` run).

* Repo: `Ivan-Johnson/docket`, branch `experimental`. Skill chain: `/to-spec`,
  `/to-tickets`, `/implement-spec`.

## What happened

* "Retry is a Proposal, not an Outcome" met code where Proposals are keyed by
  Outcome (#87).
* `--add-dir <diff dir>` met a layout with every diff in one shared directory
  (found by the code review fix).
* "#81 says Comments come only from Consolidate" conflicted with #77 (#93).
* The Verdict table lists a Post review Proposal, yet says posting runs when
  the Verdict is ruled.
* Whether implementation sees the design Ruling reached the user only through
  #89.
