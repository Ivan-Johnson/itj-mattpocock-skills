# Code Prototype

A minimal, real module that compiles with the project's toolchain. Use this when the question is about **type signatures, borrow-checker validity, trait bounds, module boundaries, or generated code shape** — the kind of thing that looks reasonable on paper but only reveals its constraints when the compiler runs.

Because it uses the real toolchain, the artifact *is* the feedback loop: compile errors, test output, macro/AST expansions, and generated asm are the "state" you surface. The prototype evolves by editing code and re-running the check command until the question is answered.

## When this is the right shape

* "Does this trait bound / generic signature actually work for the real types?"
* "Can I express this state machine as a typestate without borrow-checker fights?"
* "What does the macro expand to, and does the generated code compile?"
* "Which of these three linked-list layouts (raw pointer, BSD queue.h, macro-generated) satisfies the aliasing rules?"
* "Does this module boundary actually enforce the encapsulation I think it does?"
* Anything where the question is **answered by the compiler**, not by a human clicking buttons.

If the question is "does this state model feel right to a non-developer" or "what should this UI look like," this is the wrong branch. Use [LOGIC.md](LOGIC.md) or [UI.md](UI.md).

## Process

### 1. State the question

Before writing any code, write down the exact question at the top of the prototype module (in a
visible doc comment or a `README.md` in the prototype dir) and confirm it with the human if they're
around. The question is the contract: what counts as "answered," and who gets to say so. A code
prototype that answers the wrong question is pure waste, so make the question explicit so it can be
checked later — whether you're returning to it AFK or handing off to another session.

### 2. Create the prototype until it compiles

Create the prototype as a new subdirectory under the project's top-level, build-flag-gated
`prototypes/` directory (or equivalent), named for the question being answered. The area is compiled
only when explicitly opted in (e.g. `--features prototype` in cargo, a CMake option, a Make target)
and is **not** built by default — the usual check command skips it.

* The prototype depends on the real project modules as path/workspace dependencies.

* A prototype answers one question. If a sibling prototype (another subdirectory in the same area)
  needs a type this one defines, the sibling imports it directly from this subdirectory.

* Produce **candidate options** (the signature variants, struct shapes, module boundaries, usage
  sketches) that the question is choosing between, not a single answer.

Run the project's check command (the prototype's opt-in variant, e.g. `cargo check --features
prototype` or `make -C prototypes/<name> check`) in a tight loop until:

* The code compiles cleanly (the check passes), **AND**

* The relevant tests pass (the project's test command, prototype opt-in), **AND**

* You can point at the specific type / function / macro expansion that proves the answer.

**The compiler output is your state panel.** Read every error. The compile check is a **precondition
for the next step**, not the design answer — it confirms the design is *coherent*, not that it's the
design the human wants. If the compiler says no, the prototype *is* the debug session: edit,
re-check, repeat.

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

* If the answer is a macro expansion, capture it (e.g. an expansion snapshot), or prove the negative
  case with a compile-failure test.

This is the "surface the state" rule adapted for code: the *answer* is the state, and it lives in
the code.

Per the [SKILL](SKILL.md), the prototype itself is a primary source. Since it lives on `main`
(build-flag-gated), it's already captured in place — no throwaway branch. The answer is recorded in
the decision commit (and the tracker, if there is one). When the design question closes, the
prototype subdirectory may be deleted. Git history keeps it recoverable.

## Anti-patterns

* **Don't add tests before it compiles.** Tests lock in the answer; the compiler finds it. Add them
  once the answer is in, to freeze the decision — which is when the prototype stops being a
  prototype and becomes the implementation.

* **Don't modify the real modules while a prototype is active.** If the prototype needs a change in
  the real code to even compile, that's a signal the prototype is the wrong shape, or the question
  is bigger than one prototype. Stop, re-scope, and only edit real modules once the prototype's
  question is answered and the decision is being made for real.

* **Don't mock the real dependencies.** Use the real project types and interfaces. Mocks hide the
  exact constraints (lifetimes, trait bounds, generics) that the prototype exists to surface.

* **Don't generalize.** The prototype answers *one* question. No "what if we later want X." If a
  follow-up question arises, it's a new prototype (a new subdirectory in the same area).

* **Don't skip the build gate.** If the prototype area is built by default, its errors block the
  usual check command. The gate is what makes "throwaway but on main" work.

* **Don't let the prototype area grow past the active question set.** Subdirectories for closed
  questions are throwaway. Delete them when the question closes, or leave them only when their git
  history is the capture (see step 4).
