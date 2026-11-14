# Evidence: docket v0.1

One instance where `/wayfinder` bit me. Feeds the "Not yet specified" fog in the Trailblazer map (`../README.md`).

## Context

- Date: 2026-11-08.
- Repo: `Ivan-Johnson/docket`.
- Map: [Wayfinder: docket v0.1](https://github.com/Ivan-Johnson/docket/issues/2). Destination: "a v0.1 spec for docket detailed enough to split into implementation tickets".
- Skill chain this session: `/wayfinder` (resume), `/ask-matt`, `/to-spec`, `/to-tickets`.
- Earlier wayfinder work on this map (before this session) closed the decision tickets #3–#7 and #11.
- Outputs: spec #29 (the first copy, #18, was deleted), tickets #19–#28 on the v0.1 milestone.
- Session ID: 419fcbe0-7214-4cb9-8e55-8576efc9f290.

## Expected versus actual

- Expected: with a roughly known destination, start building and sort out decisions as they arise.
- Actual: the map's destination was a plan (a full spec), so the effort was about charting the route, not walking it.

## Bites

1. **Fog seemed to need clearing before building.** `/wayfinder` resumed with no open tickets and only fog left. The natural next step looked like graduating all the fog into tickets. `/ask-matt` also says a map hands off only once it clears. The `ready-for-agent` label on the spec reinforced this, although it is just `/to-spec`'s default.
2. **One spec for a collection of features.** v0.1 is many features (TUI, config, runner, parameters), but `/to-spec` and `/to-tickets` assume one feature. Everything got lumped into one spec issue.
3. **`/to-spec` doesn't interview, so the fog got filled with guesses.** Config format, exit codes, run order, logging and invocation were all "decided" by me as defaults. One was wrong: I picked TOML, and the config format was still open. You had to correct it.
4. **Wrong facts, same root.** I said the TUI prototype was only on its own branch, but it was on mainline. Not caused by the skill, but stale assumptions are more likely when a plan is written ahead of the work.
5. **Churn from the plan-first shape.** The spec issue was deleted (#18) and republished (#29), the ticket Parent lines were rewritten, and the ticket breakdown was revised twice before publishing.

## What worked

- The early decision tickets had real value: taskchampion versus the CLI, the stored payload format, the TUI prototype, and the action-kind design. They were conversations or research that code couldn't settle.
- The prototype ticket in particular (a throwaway TUI for you to react to) matched "learn by doing".

## Counter-evidence (against a new skill)

- A map's Notes could have said "carry execution into the map" (wayfinder's own "Plan, don't do" override), and the destination could have been "walking skeleton" instead of "full spec".
- The bites above are mostly about how the destination was named, not about the skill's mechanics.

## Signals for the open questions

- Separate skill versus a recipe: this instance leans towards a recipe or a Notes convention, unless the replan loop needs its own mechanics.
- Better destination for this effort: "a working walking skeleton, plus a decision log", not "a spec".
- The Not yet specified fog in a map worked as a signpost, but it became a to-do list for me to pre-decide. A trailblazer map might keep fog explicitly unplanned.

## Outcome

I abandoned the map-and-spec shape. Map #2 was closed as resolved, spec #29 as not planned, and the remaining work became standalone tickets #19–#28 on the v0.1 milestone. Each ticket now carries the decisions it needs and links the closed decision tickets, and #21 (the config format, which was still fog) is labelled `ready-for-human`. My take: wayfinder fits small areas in high detail or large areas in low detail, but not a large area in high detail.

## Pointers

- Map (closed): https://github.com/Ivan-Johnson/docket/issues/2
- Spec (closed, not planned): https://github.com/Ivan-Johnson/docket/issues/29
- Tickets: https://github.com/Ivan-Johnson/docket/issues?q=milestone%3Av0.1
- Prototype: `prototypes/tui-layout` on `mainline` in the docket repo
