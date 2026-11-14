# Evidence: docket v0.1, ticket #20

One instance where `/to-spec` and `/to-tickets` produced tickets that went
wrong. Feeds the "Not yet specified" fog in the map (`../README.md`).

NOTE: This instance is weak evidence, since Ivan-Johnson/docket#20 was created
from [a weak wayfinder map](../../Trailblazer/Evidence/docket-v0.1.md).

## Context

* Date: 2026-11-08 (tickets written), 2026-11-14 (aftermath).

* Repo: `Ivan-Johnson/docket`. Skill chain: `/wayfinder`, `/to-spec`,
  `/to-tickets`. The spec issue was later closed as not planned, and the ticket
  bodies were rewritten so they stand alone.

* Session ID: 419fcbe0-7214-4cb9-8e55-8576efc9f290.

## What happened

* `/to-tickets` produced ten tickets (#19 to #28). #20, "Load and validate a
  docket", asked for the backend trait, the taskchampion adapter, the full
  payload validator and the exit codes in one ticket.

* #20 was implemented three times, in the branches
  `archive/code-review/issue-20/pass-1`, `pass-2` and `abandoned`. The first two
  passes mostly reflect setting up a new reviewer skill and
  `CODING_STANDARDS.md`.

* It was then closed as superseded by #32, a minimal add/list/delete CLI, for
  "unused code and over-built seams".

* #19 had split the crate into a library and a binary. #32 undid that split.

## Guesses the ticket left to the implementer

From `tmp.tqNiIobfKO/spec/item-*.md` on the `abandoned` branch:

* the shape of an action,
* date-default syntax (the ticket said only "defaults are literal strings"),
* whether a title with a line break is rejected,
* the exit code when the store won't open (the ticket said only 0, 1 and 2),
* whether a parameter's `default` is mandatory,
* the trait's scope (completing and annotating, later deleted as unneeded),
* list-of-proposals vs one field per outcome (I haven't verified which ticket
  decided what).

Some of these came from the agent, not from the decision tickets: "Errors go to
stderr only", the exit codes and the trait scope.

Added after the 2026-11-14 review session:

* The tickets contradicted each other. #20 asked for a "`ReadOnly` taskchampion
  adapter", and said its trait also covered completing and annotating an Item.
  #26 says the runner marks Items completed "through a `ReadWrite` adapter". So
  #20 forced stubs that return `Error::ReadOnly`. The "trait scope" guess above
  was only the visible half of this.

* For list-of-proposals vs one field per outcome: #6 (a comment) shows a list
  of proposals, each with an `outcome` key, and says "at most one of each per
  item". The user recalls another ticket deciding one field per outcome, and
  calls the mismatch a spec bug. I haven't found that other ticket.

* Two requirements the user did not care about: exit codes finer than zero vs
  non-zero, and "one stderr line per error". The second drove `Lenient<T>`, the
  per-error accumulation and the parallel `Malformed` error variants in
  `uda.rs` (about 280 lines). The user would settle for reporting only the
  first problem.

* #19's acceptance criterion "the binary and library are split so tests can
  call library entry points" prescribed a solution. The user's later view: the
  crate should be binary-only with nothing `pub`, tests beside the code, and a
  few `tests/` tests running the binary. #19's split is why `pub mod cli`
  existed.

* Cost of the horizontal ticket: of 18 standards items and 5 spec items found
  by the review, 6 still applied to the replacement plan. The rest were moot,
  so reviewing the over-built code was mostly wasted.

* #22 to #28 were written against the horizontal model (proposals, parameters,
  the UDA payload). Replacing #20 may mean rewriting them. I haven't checked
  whether that was already done.

The spec also listed config location, data dir, filtering, run order, logging
and exit codes as "Defaults chosen". The config format was still undecided, and
the agent had picked TOML.

## What a better ticket looks like

`tmp.tqNiIobfKO/new-ticket.md` (which became #32):

* A tiny slice that runs end to end: `add <title>`, `list`, `delete <uuid>`.

* Acceptance criteria that cover failure: an invalid title writes nothing and
  exits non-zero, a malformed uuid exits non-zero, and a store that can't be
  opened exits non-zero.

* The crate and standards changes that go with it are in the ticket.

* The trait is written in domain words and covers only what the three commands
  use. No stubs and no `#[expect(dead_code)]`.

## Pointers

* `tmp.tqNiIobfKO/decisions.md` and `tmp.tqNiIobfKO/new-ticket.md` on
  `origin/archive/code-review/issue-20/abandoned`.

* The `/itj-retro` record:
  `~/Tmp/itj-retro/2026-11-14-docket-v0.1-tickets/record.md` (items 1, 2 and 3).

* Tickets: `Ivan-Johnson/docket#19`, `#20` (closed, superseded) and `#32`.
