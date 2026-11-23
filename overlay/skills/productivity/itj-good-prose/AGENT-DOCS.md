# Agent docs

What changes when the reader is an agent: a skill, an `AGENTS.md` /
`CLAUDE.md`, or a doc reached by a pointer. The standard in
[`SKILL.md`](SKILL.md) applies in full. An agent takes the same *process*
every run rather than producing the same output, and the levers below make
that process predictable.

For a skill, also read [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md)
(frontmatter, invocation choice, router skills).

## Context pointers

A **context pointer** is a pointer held in the agent's context: a skill's
description, a line in `AGENTS.md` naming a doc. It states what the material
is and the branches that trigger reaching it. Its wording decides when, and
how reliably, the agent reaches the target. Every word of an always-loaded
pointer is paid on every turn, so prune it harder than the body.

## The two loads

Every document and pointer you add spends one of two budgets:

* **Context load**: always-loaded material on the agent's window (an
  `AGENTS.md` line, a skill description), paid whether or not it fires.
* **Cognitive load**: the human's burden of remembering which documents exist
  and when to reach for each. The human is the index. Not a cost to minimise:
  it is the price of human agency; spend it where human judgement matters.

Material reached only through a pointer escapes context load at the price of
the pointer's line; material with no pointer rides entirely on cognitive load.

## Premature completion

The post-completion steps (the visible steps still ahead) pull the agent to
rush the one in front of it. Defend in order:

1. **Sharpen the bound** (local and cheap).
2. Only if it is irreducibly fuzzy *and* you observe the rush, **split by
   sequence**: hide the later steps. This works only across a real context
   boundary (a hand-off or a subagent dispatch; an inline call leaves them in
   context).

Merging sequences exposes each step to the steps after it, inviting the rush.

## Demand

A criterion's *demand* drives **legwork**, the digging latent in its wording:
"every rule applied" binds flat reference as "every step done" binds a
sequence, so an all-reference document still carries an exhaustiveness bar.

## Leading words in pointers

The same leading word in your prompts, your docs, and your codebase links that
shared language to the material, so the agent reaches it more reliably.

## Repeated output

A skill that reports the same kind of information every run (a task
recommendation, a status summary, a review verdict) gives the exact output
template in the skill, so every run reads the same. The template ends in one
question the user can answer by voice: "yes" to accept the recommendation, or
"one", "two" or "three" to pick an option.
