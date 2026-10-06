# Code Prototype

A minimal, real module that compiles with the project's toolchain. Use this when the question is about **type signatures, type-system validity, trait/constraint bounds, module boundaries, or generated code shape** — the kind of thing that looks reasonable on paper but only reveals its constraints when the toolchain runs.

## When this is the right shape

* "Does this trait bound / generic signature actually work for the real types?"
* "Can I express this state machine in a form the type system enforces at compile time?"
* "What does the macro or template expand to, and does the generated code compile?"
* "Which of these three data-structure implementations satisfies the language's memory/aliasing rules?"
* "Does this module boundary actually enforce the encapsulation I think it does?"
* Anything where the question is **answered by the compiler or type checker**, not by a human clicking buttons.

If the question is "does this state model feel right to a non-developer" or "what should this UI look like," this is the wrong branch. Use [LOGIC.md](LOGIC.md) or [UI.md](UI.md).

## Process

### 1. State the question

Before writing any code, write down the exact question at the top of the prototype module (in a
visible doc comment or a `README.md` in the prototype dir) and confirm it with the human if they're
around. The question is the contract: what counts as "answered," and who gets to say so. A code
prototype that answers the wrong question is pure waste, so make the question explicit so it can be
checked later — whether you're returning to it AFK or handing off to another session.

### 2. Draft the prototype

The prototype's location and build wiring come from `docs/prototypes.md` at the project's top
level (a [template](prototype-doc-template-rust.md) for rust projects is included with this skill).
If the file is missing, stop and tell the user: the prototype area and its build wiring are a
project convention, and the user must create `docs/prototypes.md` before code prototypes can
proceed.

Each prototype is **independent**: it depends only on the real project modules (as
path/workspace dependencies) and on the standard library. If a prototype wants to reuse something
another prototype defines, that's a sign the two questions belong in one prototype. Ask the user
whether to merge them into a single prototype (e.g. `prototypes/<baz>/{foo,bar}`). If the user isn't
available, duplicate the code into the new prototype instead: prototypes are throwaway, so a copy
is cheaper than a wrong dependency.

Produce **candidate options** (the signature variants, struct shapes, module boundaries, usage
sketches) that the question is choosing between, not a single answer. **Each candidate must compile
on its own.** A candidate that doesn't is a *rejected option*, not a finding: delete it or comment it
out and note the reason next to the question from step 1. The prototype as a whole stays green; a
failed build is a record, not a resident.

Run the project's default check command (which compiles all prototypes) in a tight loop until the
code compiles cleanly and you can point at the specific type, function, or macro expansion that
proves the answer.

The compile check is a **precondition for the next step** — it confirms the
design is *coherent*, but it does not confirm that the human actually wants this
design.

### 3. Show it to the human

Open the prototype and surface the candidate options the prototype produced (the signature variants,
struct shapes, module boundaries, usage sketches), then ask the question. Three outcomes:

* **Final decision** — the human picks an option (or a hybrid of several). Proceed to step 4.

* **Iterate** — the human rejects or redirects. That's the next iteration's direction. Back to step
  2; the prototype evolves.

* **Ambiguous / "depends"** — the question was bigger than one prototype. Split it or re-scope. Stop
  and talk rather than iterate blindly.

### 4. Surface the answer and capture

Once the decision is made, make the answer **visible in the source** so a future reader (or you, AFK) doesn't have to re-derive it:

* Add an `ANSWER:` doc comment at the top of the module summarizing the decision.

* If the answer is a type signature, put it in a named, grep-able type or constant.

* If the answer is a macro expansion, capture it as an expansion snapshot. A rejected option is not
  captured as a compile-failure: its absence from the candidate list, plus the question log, is the
  record.

This is the [surface the state](SKILL.md) rule adapted for code: the *answer* is the state, and it
lives in the code.

Per the [SKILL](SKILL.md), the prototype itself is a primary source. Since it lives on `main`
(build-flag-gated), it's already captured in place — no throwaway branch. The answer is recorded in
the decision commit (and the tracker, if there is one). When the design question closes, the
prototype subdirectory may be deleted. Git history keeps it recoverable.

## Anti-patterns

* **No tests.** The compiler is the check; a prototype that wants tests has outgrown itself. Writing
  them means you're writing the real implementation, which is past the prototype's scope.

* **No non-compiling candidate in the tree.** The prototype is a green build at rest; a dead option
  is a dead file, not a failing test.

* **Don't modify the real modules while a prototype is active.** If the prototype needs a change in
  the real code to even compile, that's a signal the prototype is the wrong shape, or the question
  is bigger than one prototype. Stop, re-scope, and only edit real modules once the prototype's
  question is answered and the decision is being made for real.

* **Don't mock the real dependencies.** Use the real project types and interfaces. Mocks hide the
  exact constraints (lifetimes, trait bounds, generics) that the prototype exists to surface.

* **Don't generalize.** The prototype answers *one* question. No "what if we later want X." If a
  follow-up question arises, it's a new prototype (a new subdirectory in the same area).

* **Don't link a prototype into the primary target.** Prototypes compile as standalone libraries
  so they exercise the real toolchain, but if one is linked into the main target, a throwaway
  mistake ships as production.

* **Don't let the prototype area grow past the active question set.** Subdirectories for closed
  questions are throwaway. Delete them when the question closes, or leave them only when their git
  history is the capture (see step 4).
