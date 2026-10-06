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

The project maintains a **build-flag-gated prototype area** — a workspace member or top-level directory excluded from default builds and compiled only when explicitly opted in (e.g. `--features prototype` in cargo, a CMake option, a Make target). It:

* Depends on the real project modules as path/workspace dependencies.
* Contains a `common/` module for types that graduate to become shared contracts across prototypes.
* Contains one sandbox per active design question (one directory per question, e.g. `question-a/`, `question-b/`).
* Is **not** built by default — the usual check command skips it. Run the prototype's check command explicitly when working on a prototype.

Create your prototype as a new module or file in its sandbox (a sub-crate / separate build unit if it needs its own dependency manifest). Use the real dependencies, real types, real macros — no mocks, no stubs, no test-gating.

### 3. Iterate with the compiler

Run the project's check command in a tight loop (the prototype's opt-in variant, e.g. `cargo check --features prototype` or `make -C prototype/<sandbox> check`).

**The compiler output is your state panel.** Read every error. The question is answered when:
* The code compiles cleanly (the check passes), **AND**
* The relevant tests pass (the project's test command, prototype opt-in), **AND**
* You can point at the specific type / function / macro expansion that proves the answer.

If the compiler says no, the prototype *is* the debug session. Edit, re-check, repeat.

### 4. Surface the answer in the code

Once it compiles, make the answer **visible in the source** so a future reader (or you, AFK) doesn't have to re-derive it:

* Add a `ANSWER:` doc comment at the top of the module summarizing the decision.
* If the answer is a type signature, put it in a named, grep-able type or constant.
* If the answer is a macro expansion, capture it (e.g. an expansion snapshot), or prove the negative case with a compile-failure test.

This is the "surface the state" rule adapted for code: the *answer* is the state, and it lives in the code.

### 5. Graduate or discard

**Graduate (the happy path):** The validated types / functions / macros move out of the sandbox and into:
* `common/` — if they're shared contracts for other prototypes in the same sandbox.
* The real module — if they're the final production shape. This is the normal path: the prototype *becomes* the implementation.

**Discard (the learning path):** The prototype proved the approach doesn't work. Delete the module. The answer ("this doesn't work because...") is captured in the commit message that deletes it, or in whatever tracker the design question lives in.

Either way, the sandbox directory is **throwaway** — it disappears when the design question closes. Only `common/` and the real modules persist.

### 6. Capture the prototype as a primary source

Per the [SKILL](SKILL.md), the prototype itself is a primary source. Since it lives on `main` (build-flag-gated), section 5 *is* the capture:
* If graduated → the real module *is* the capture; delete the sandbox.
* If discarded → the commit message + the git history of the sandbox (on `main`) are the capture. Optionally, tag the commit (`<sandbox>/discarded`) before deleting.

No separate branch needed. The build gate keeps it off default builds; the workspace keeps it composable; git history keeps it recoverable.

## Anti-patterns

* **Don't add tests before it compiles.** Tests lock in the answer; the compiler finds it. Add them once the answer is in, to freeze the decision — which is when the prototype stops being a prototype and becomes the implementation.
* **Don't mock the real dependencies.** Use the real project types and interfaces. Mocks hide the exact constraints (lifetimes, trait bounds, generics) that the prototype exists to surface.
* **Don't generalize.** The prototype answers *one* question. No "what if we later want X." If a follow-up question arises, it's a new prototype (possibly in the same sandbox, reusing `common/` types).
* **Don't blur the prototype and the real module.** The prototype imports from the real module; the real module never imports from the prototype (except via `common/` types that have explicitly graduated). Directionality: `prototype → real`, never `real → prototype`.
* **Don't skip the build gate.** If the prototype area is built by default, its errors block CI and the usual check command. The gate is what makes "throwaway but on main" work.
* **Don't persist prototype-only types in `common/` forever.** `common/` is for *shared contracts* — types that two or more prototypes in the *same sandbox* depend on. If only one prototype uses it, it stays in that prototype's module. If the sandbox closes and no other sandbox needs it, `common/` gets cleaned too.

---

*This branch follows the same six rules as [LOGIC.md](LOGIC.md) and [UI.md](UI.md): throwaway from day one, trivial to run, no persistence by default, skip the polish, surface the state, capture it when done. Only the artifact and feedback loop change.*
