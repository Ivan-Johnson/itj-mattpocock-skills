---
name: itj-good-prose
description: >-
  Rules for any prose you write: skills, AGENTS.md / CLAUDE.md, READMEs and
  docs, code and doc comments, ADRs, commit messages, PR bodies, and messages
  (Slack, email, ticket or CR comments). Use when writing or editing any of
  them.
---
# Good prose

Covers sentences and structure alike. Every reader is an *outsider to your
session*: they never saw your debugging, your rejected attempts, or this
conversation.

## Reader

Name the reader before writing: who they are, what they know, what they want.
`FORMS.md` tabulates the common forms.

A doc's first lines name its readers, in the repo's audience vocabulary (from
`AGENTS.md`) when it has one. **Split** when some named reader does not need a
claim: a fact about the subject stays on one shared page; role-specific
procedure or rationale goes in a separate doc that links to it.

## Content

* **Lead** with what the reader wants: the first sentence answers their
  question.
* **Non-obvious.** Keep a fact when finding it elsewhere is *costly*; cut it
  when one cheap lookup returns it.
  * cheap: a signature, `--help`, a config file, or a grep where you already
    know what to grep for and where.
  * costly: a grep you would only run if you already knew the answer, a fact
    that needs a live run, or code whose reason is hard to read off it. The
    *why* behind odd code is kept even if careful reading could recover it.
* **Cache.** Restating what the environment already says (signatures, flags,
  fields, directory layout) is a *cache* of that lookup: link the source of
  truth instead, so nothing goes stale. Cache only what looking cannot find:
  the unwritten convention, the reason behind a choice, the *footgun*.
* **Why.** The reader sees the *what* (the code, the diff); add what they
  cannot see from where they stand.
* **Present tense.** A fact reads as true now. History (debugging stories,
  rejected alternatives, "previously…") belongs in the forms whose reader
  wants it: commit messages, PR bodies, ADRs.
* **Bounded.** A claim carries the scope that bounds it. For a reader who
  consumes conclusions, that is the conclusion's scope, never the
  experiment's setup or trial counts. A claim that cannot be concluded is
  cut, not marked untested; an open question goes to the issue tracker.
* **No-ops.** A sentence the reader already obeys by default says nothing;
  delete the whole sentence. The test is relative to the reader: for a model,
  settle disagreement by running the document, not by debate.

## Structure

* **One home.** Each fact lives once, under the thing it describes, so a
  change is a one-place edit. A page shaped like an experiment is dissolved
  into its subjects. Duplication costs upkeep and inflates a meaning's
  prominence.
* **Co-location.** Keep a concept's definition, rules, and caveats under one
  heading. Duplication repeats a meaning; scattering fragments one.
* **Hierarchy.** Order material by how immediately the reader needs it:
  1. *steps*: what to do, in order;
  2. *in-file reference*, consulted on demand (a flat peer-set is fine);
  3. *disclosed reference*: a separate file behind a **pointer** (a link, a
     table-of-contents entry), reached only when the pointer fires.

  Inline what every branch needs (a *branch* is a distinct case the document
  handles); disclose what only some branches reach. Reference left in-file
  buries the steps.
* **Pointers.** The wording decides when the target is reached. Say what the
  material is, then one trigger per branch (synonyms are one branch written
  twice), leading word first. Cut identity the body already carries. A
  must-have target behind a weak pointer is a defect: sharpen the wording
  first, inline only if that fails.
* **Sprawl.** A document too long even when every line is live thins the
  reader's attention. Cure it with the hierarchy: disclose reference, and
  split by branch or sequence so each path carries only what it needs. A
  10,000-word README wants a table of contents.
* **Sediment.** Stale layers settle because adding feels safe and removing
  feels risky. Check each line's relevance: does it still bear on what the
  document does? Shorter documents stay relevant more easily.
* **Completion criteria.** Every step (a runbook's, a tutorial's, a skill's)
  ends on a criterion the reader can check, and the strongest are exhaustive
  too ("every modified model accounted for", not "produce a change list").
  A vague bound invites *premature completion*; sharpen it first.
* **Leading words.** A compact, well-known word (*lesson*, *tight*, *red*,
  *tracer bullet*) repeated as a token anchors a region of behaviour. A triad
  spelled out at three sites collapses into one such word. Reach for an
  existing word before coining one.
* **Positive.** State the behaviour you want; a prohibition drags the
  forbidden thing into view. Keep a ban only as a hard guardrail, paired with
  the positive target.

## Forms

* Comment, README, ADR, commit message, PR body, message (Slack, email,
  ticket or CR comment): `FORMS.md`.
* Skill, `AGENTS.md`, `CLAUDE.md`, or any doc an agent reads: `AGENT-DOCS.md`.

## Iterate

Done when every sentence tells the reader something they want and don't
already know, and every fact has one home.
