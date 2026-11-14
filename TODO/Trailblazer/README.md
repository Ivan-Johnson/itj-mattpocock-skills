# Map: trailblazer

## Destination

A new `/trailblazer` skill, for work where the destination is roughly known but
the way can't be charted in advance. This is tentative: the name, whether it is
a separate skill at all, and the destination itself are all open (see Not yet
specified).

## Notes

* Wayfinder: you're on top of a barren mountain. Once you've found the
  destination you can see it, and you use a telescope to chart a safe route that
  avoids hazards. The fog is clearable from where you stand (radar or an
  infrared telescope pierces it without moving).

* Trailblazer: the fog can't be cleared from where you stand. The destination is
  hidden by the curvature of the earth, or you're in a jungle where you can only
  see the destination from up a tree, and then you can't see the hazards below
  the canopy. Planning the full route is impossible, so you move, then re-plan
  from the new position.

  Far superior metaphor, I think: you're trying to put together a puzzle. The
  puzzle has a "perimeter" rather than a "destination". The work is done when
  the puzzle is "solved." Advantages of this metaphor:

  * You can progress along multiple routes at once

  * It's hard to start new a new "island". It's easier to expand out from what
    you've already solved.

	This gives a clear contrast with the wayfinder skill (at least on a
    metaphorical level --- I'm not sure if the analogy actually holds in the
    real world).

  * you can start putting pieces together immediately; you don't need to see the
    full picture, or even the entire perimeter.

* Trigger: I keep getting bitten by `/wayfinder`. I learn by doing, and I don't
  want to chart the entire route before my first step. A rough destination is
  enough to start moving.

* Wayfinder's "Plan, don't do" section already says an effort can override
  planning in its Notes, "carrying execution into the map itself". That may make
  a separate skill unnecessary.

* Open question: when does a problem need `/wayfinder`, and when not? I don't
  understand this yet, and it is itself evidence. Per `/wayfinder`'s own text
  it is for efforts "too big for one session" whose route isn't visible, and it
  produces decisions, not deliverables. Both evidence files
  ([docket v0.1](Evidence/docket-v0.1.md),
  [itj_daemon](Evidence/itj-daemon-tinydeps.md)) are cases where I picked it and
  it didn't fit how I wanted to work. Two instances aren't enough to say more.

* Everything here is tentative and subject to change.

## Decisions so far

<!-- one line per decision, with a link to where its detail lives -->

## Not yet specified


* Is the "trailblazer skill" even the right destination? It could instead be a
  change to `/wayfinder`, a convention in a map's Notes, a different workflow
  built from existing skills, or no change at all.

* Is trailblazer really different from wayfinder? Wayfinder's "Plan, don't do"
  override, plus a map that doesn't clear all its fog before building, might
  already cover it. If so, the finding is a recipe and not a skill.

* If it is separate: a fork of wayfinder, a standalone skill that borrows its
  map and ticket conventions, or something else.

* The name. Candidates so far: `/trailblazer`, `/dead-reckoning`,
  `/rolling-wave`, `/next-step`.

* What the loop looks like when the fog can't be cleared: how it picks the next
  step, when it replans, and how a decision gets recorded.

* How it relates to the map when features are separate: one map per release
  (docket v0.1 was a collection of features), or one per feature.

* Where it hands off, and whether it ends at a spec at all or goes straight to
  implementation.

* Which existing skills it should lean on: `/grill-with-docs`, `/tdd`,
  `/prototype`, `/to-tickets`.

## Out of scope

TBD
