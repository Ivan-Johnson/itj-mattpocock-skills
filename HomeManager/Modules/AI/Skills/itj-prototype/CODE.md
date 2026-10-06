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

Before writing code, write down the exact question at the top of the prototype module (in a visible doc comment or a `README.md` in the prototype dir). A code prototype that answers the wrong question is pure waste. Make the question explicit so it can be checked later — whether you're returning to it AFK or handing off to another session.

### 2. Create the prototype in the shared prototype area

The project maintains a **build-flag-gated prototype area** at the top-level `prototypes/` directory (or equivalent), compiled only when explicitly opted in (e.g. `--features prototype` in cargo, a CMake option, a Make target). Create your prototype as a new subdirectory under it, named for the question being answered.

* The prototype area is **not** built by default — the usual check command skips it. Run the prototype's check command explicitly when working on it.
* The prototype depends on the real project modules as path/workspace dependencies.
* A prototype answers one question. If a sibling prototype (another subdirectory in the same area) needs a type this one defines, import it directly from this subdirectory.

### 3. Iterate with the compiler

Run the project's check command in a tight loop (the prototype's opt-in variant, e.g. `cargo check --features prototype` or `make -C prototypes/<name> check`).

**The compiler output is your state panel.** Read every error. The question is answered when:
* The code compiles cleanly (the check passes), **AND**
* The relevant tests pass (the project's test command, prototype opt-in), **AND**
* You can point at the specific type / function / macro expansion that proves the answer.

If the compiler says no, the prototype *is* the debug session. Edit, re-check, repeat.

### 4. Surface the answer in the code

Once it compiles, make the answer **visible in the source** so a future reader (or you, AFK) doesn't have to re-derive it:

* Add an `ANSWER:` doc comment at the top of the module summarizing the decision.
* If the answer is a type signature, put it in a named, grep-able type or constant.
* If the answer is a macro expansion, capture it (e.g. an expansion snapshot), or prove the negative case with a compile-failure test.

This is the "surface the state" rule adapted for code: the *answer* is the state, and it lives in the code.

### 5. Capture the prototype as a primary source

Per the [SKILL](SKILL.md), the prototype itself is a primary source. Since it lives on `main` (build-flag-gated), it's already captured in place. When the design question closes:
* If the approach worked → the answer is recorded in the commit that records the decision (and in the tracker, if there is one).
* If the approach failed → the answer ("this doesn't work because...") is recorded the same way, and the prototype subdirectory may be deleted.

No separate branch needed. The build gate keeps it off default builds; git history keeps it recoverable.

## Anti-patterns

* **Don't add tests before it compiles.** Tests lock in the answer; the compiler finds it. Add them once the answer is in, to freeze the decision — which is when the prototype stops being a prototype and becomes the implementation.
* **Don't modify the real modules while a prototype is active.** If the prototype needs a change in the real code to even compile, that's a signal the prototype is the wrong shape, or the question is bigger than one prototype. Stop, re-scope, and only edit real modules once the prototype's question is answered and the decision is being made for real.
* **Don't mock the real dependencies.** Use the real project types and interfaces. Mocks hide the exact constraints (lifetimes, trait bounds, generics) that the prototype exists to surface.
* **Don't generalize.** The prototype answers *one* question. No "what if we later want X." If a follow-up question arises, it's a new prototype (a new subdirectory in the same area).
* **Don't skip the build gate.** If the prototype area is built by default, its errors block the usual check command. The gate is what makes "throwaway but on main" work.
* **Don't let the prototype area grow past the active question set.** Subdirectories for closed questions are throwaway. Delete them when the question closes, or leave them only when their git history is the capture (see section 5).

---

*This branch follows the same six rules as [LOGIC.md](LOGIC.md) and [UI.md](UI.md): throwaway from day one, trivial to run, no persistence by default, skip the polish, surface the state, capture it when done. Only the artifact and feedback loop change.*
