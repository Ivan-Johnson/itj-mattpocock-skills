# Map: tweak `/to-spec` and `/to-tickets`

## Destination

Small patches to upstream's `to-spec` and `to-tickets` skills, so that the
tickets they produce are real vertical slices and don't contain requirements
nobody decided. Each patch lives in `patches/` (see this repo's README, "Editing
a patch"). Everything here is tentative and subject to change.

## Notes

* Trigger: specs and tickets written by `/to-spec` and `/to-tickets` that had
  to be abandoned and rewritten, or that left conflicts for implementers to
  find. Each instance is a file in [Evidence/](Evidence/):
  [docket v0.1, ticket #20](Evidence/docket-v0.1-ticket-20.md) and
  [docket native code review](Evidence/docket-native-code-review.md).

* The Trailblazer map's [docket v0.1 evidence](../Trailblazer/Evidence/docket-v0.1.md)
  covers the same session. Whether wayfinder fits this kind of effort at all is
  Trailblazer's question, not this map's.

* The two skills are upstream's. The way to change them is a patch (see this
  repo's README). I haven't confirmed that the patches should go to upstream
  instead.

## Decisions so far

<!-- one line per decision, with a link to where its detail lives -->

## Not yet specified

* `/to-tickets`, step 3 (vertical slices): the first ticket of a feature should
  run through the real entry point (a CLI command, a screen) and add only the
  types, traits and structure its own behaviour uses. A ticket whose only output
  is a model, a trait or a validator is horizontal, even with tests. #19's
  lib/bin split (undone by #32) and #20 are the examples. Open: how to word it
  so it also covers prefactoring that really is needed.

* `/to-tickets`, steps 4 and 5 (quizing and publishing): a ticket should quote
  what was decided and label everything else as a proposed default or an open
  question. It should state error behaviour (exit codes, messages) for each
  failure mode it introduces, and the tickets shouldn't contradict one another.
  Examples: action shape, date-default syntax, title line breaks, the exit code
  when the store won't open, whether `default` is mandatory, trait scope, and
  list-of-proposals vs one field per outcome. Open: whether that is a rule in
  the skill or a check the agent runs before publishing.

* `/to-spec`, step 3 (writing the spec): the skill says "Do NOT interview the
  user", so the agent decided the unresolved details itself (config location
  and format, exit codes, run order, logging). The spec should list what the
  decisions leave open under "Open questions", with no default, and keep
  Implementation Decisions for what was decided. Open: whether `/to-spec`
  should instead be allowed to ask when the source has open questions.

* `/to-spec`, steps 1 and 3 (exploring the repo; writing the spec): in step 1,
  check each Implementation Decision that names a mechanism against the code;
  in step 3, list conflicts between the source decisions and the spec's
  sections, and resolve them with the user or record them under Further Notes.
  Evidence: [docket native code review](Evidence/docket-native-code-review.md),
  where implementers found five such conflicts mid-run.

* `/to-tickets`, steps 3 and 4: a ticket should say where its tests go (the
  seam), and should not prescribe an implementation for it. #19 required a
  lib/bin split "so tests can call library entry points", and the user later
  chose a binary-only crate instead. Related: a ticket should not set a
  finer-grained behaviour than the user cares about (exit codes, "one line per
  error"). Open: whether that is a rule or part of the quizing.

* Replacing a horizontal ticket may force rewriting the tickets after it, which
  were written against its model (#22 to #28). That is a cost of horizontal
  slicing worth stating in the vertical-slice rule. See the evidence file.

* Whether these are three patches, one, or a change to wayfinder's handoff to
  `/to-spec` (see Trailblazer).

## Out of scope

* Whether wayfinder should have been used at all (the Trailblazer map).

* Wording changes to other upstream skills.
