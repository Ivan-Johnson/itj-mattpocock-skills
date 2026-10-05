# Code Prototype

A minimal, real crate or module that compiles with the project's toolchain (`cargo check`, `cargo test`, `gcc`, `make`). Use this when the question is about **type signatures, borrow-checker validity, trait bounds, module boundaries, or generated code shape** — the kind of thing that looks reasonable on paper but only reveals its constraints when the compiler runs.

Because it uses the real toolchain, the artifact *is* the feedback loop: compile errors, test output, `cargo expand`, and generated asm are the "state" you surface. The prototype evolves by editing code and re-running the check command until the question is answered.

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

Before writing code, write down the exact question at the top of the prototype module (in a visible `//!` doc comment or a `README.md` in the prototype dir). A code prototype that answers the wrong question is pure waste. Make the question explicit so it can be checked later — whether you're returning to it AFK or handing off to another session.

### 2. Create the prototype in the shared `prototype/` crate

The project maintains a **feature-gated `prototype/` workspace member** (enabled via `cargo check --features prototype`). This crate:

* Depends on the real workspace crates (`itj_tiny_deps`, `itj_tiny_ipc`, etc.) as path dependencies.
* Contains a `common/` module for types that graduate to become shared contracts across prototypes.
* Contains one submodule per active wayfinding map (e.g. `ipc_plugin_map/`, `rpc_macro_map/`).
* Is **not** built by default — `cargo check` on `main` skips it. Run `cargo check --features prototype` explicitly when working on prototypes.

Create your prototype as a new module under `prototype/<map_name>/<variant>.rs` (or a sub-crate under `prototype/<map_name>/` if it needs its own `Cargo.toml`). Use the real dependencies, real types, real macros — no mocks, no stubs, no `#[cfg(test)]` gating. The prototype *is* real code; it just lives in the sandbox.

### 3. Iterate with the compiler

Run the check command in a tight loop:

```bash
# For Rust
cargo check --features prototype

# Or for a specific sub-crate
cargo check --features prototype -p prototype_ipc_plugin_map

# For C
make -C prototype/linked_list_map check
```

**The compiler output is your state panel.** Read every error. The question is answered when:
* The code compiles cleanly (`cargo check` passes), **AND**
* The relevant tests pass (`cargo test --features prototype`), **AND**
* You can point at the specific type / function / macro expansion that proves the answer.

If the compiler says no, the prototype *is* the debug session. Edit, re-check, repeat. Don't add tests until the shape compiles; tests are for locking in the answer, not finding it.

### 4. Surface the answer in the code

Once it compiles, make the answer **visible in the source** so a future reader (or you, AFK) doesn't have to re-derive it:

* Add a `//! ANSWER: ...` doc comment at the top of the module summarizing the decision.
* If the answer is a type signature, put it in a `pub type Answer = ...` or a `pub const ANSWER: &str = "..."` — something grep-able.
* If the answer is a macro expansion, include a `#[cfg(test)]` test that `cargo expand` captures, or a `compile_fail` test that proves the negative case.

This is the "surface the state" rule adapted for code: the *answer* is the state, and it lives in the code.

### 5. Graduate or discard

**Graduate (the happy path):** The validated types / functions / macros move out of `prototype/<map>/` and into:
* `prototype/common/` — if they're shared contracts for other prototypes in the same map.
* The real crate (`itj_tiny_deps`, `itj_rpc_macro`, etc.) — if they're the final production shape. This is the normal path: the prototype *becomes* the implementation.

**Discard (the learning path):** The prototype proved the approach doesn't work. Delete the module. The answer ("this doesn't work because...") is captured in the wayfinding ticket's resolution comment.

Either way, the `prototype/<map>/` directory is **throwaway** — it disappears when the map finishes. Only `prototype/common/` and the real crates persist.

### 6. Capture the prototype as a primary source

Per the [SKILL](SKILL.md), the prototype itself is a primary source. Since it lives in the `prototype/` crate on `main` (feature-gated), it's already captured. When the map finishes:
* If graduated → the real crate *is* the capture; delete `prototype/<map>/`.
* If discarded → the ticket's resolution comment + the git history of `prototype/<map>/` (on `main`) are the capture. Optionally, tag the commit (`prototype/<map>/discarded`) before deleting.

No separate branch needed. The feature gate keeps it off default builds; the workspace keeps it composable; git history keeps it recoverable.

## Anti-patterns

* **Don't add tests before it compiles.** A prototype that needs tests to pass is no longer a prototype — it's an implementation. Tests lock in the answer; the compiler finds it.
* **Don't mock the real dependencies.** Use the real `itj_tiny_deps::ipc::Connection`, the real `itj_rpc_macro::define_rpc`, the real `Controller`/`SttEngine` types. Mocks hide the exact constraints (lifetimes, trait bounds, generics) that the prototype exists to surface.
* **Don't generalize.** The prototype answers *one* question. No "what if we later want X." If a follow-up question arises, it's a new prototype (possibly in the same map, reusing `prototype/common/` types).
* **Don't blur the prototype and the real crate.** The prototype imports from the real crate; the real crate never imports from the prototype (except via `prototype/common/` types that have explicitly graduated). Directionality: `prototype → real`, never `real → prototype`.
* **Don't skip the feature gate.** If the prototype crate is built by default, its errors block CI and `cargo check`. The feature gate is what makes "throwaway but on main" work.
* **Don't persist prototype-only types in `prototype/common/` forever.** `common/` is for *shared contracts* — types that two or more prototypes in the *same map* depend on. If only one prototype uses it, it stays in that prototype's module. If the map finishes and no other map needs it, `common/` gets cleaned too.

## Example: evaluating `IpcPlugin` loop location (map #59, ticket #61)

**Question:** Should the accept/read/route/reply loop live inline in `IpcPlugin` (option A) or in a reusable `itj_tiny_deps::ipc::SingleConnServer` (option B)?

**Prototype:** Create `prototype/ipc_plugin_map/option_a.rs` and `option_b.rs`, both using real `MockConnection`, `MockServer`, `MessageConnection`, `Plugin` trait. Each implements `Plugin::poll` with its loop shape. Run `cargo check --features prototype`.

**Surface:** Both compile. Option B is 40% less code. The `SingleConnServer` signature is `poll(&mut self, handler: impl FnMut(Msg) -> Reply)`. The answer is visible in the module: `//! ANSWER: Option B (extracted). SingleConnServer compiles, is reusable, and the handler closure captures the domain via Rc<RefCell> cleanly.`

**Graduate:** `SingleConnServer` moves to `itj_tiny_deps/src/ipc/single_conn_server.rs`. `option_a.rs`/`option_b.rs` deleted. Map continues.

---

*This branch follows the same six rules as [LOGIC.md](LOGIC.md) and [UI.md](UI.md): throwaway from day one, trivial to run, no persistence by default, skip the polish, surface the state, capture it when done. Only the artifact and feedback loop change.*