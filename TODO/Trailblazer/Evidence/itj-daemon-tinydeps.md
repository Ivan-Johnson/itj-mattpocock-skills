# Evidence: itj_daemon wayfinder map and the TinyDeps work

One instance where `/wayfinder` bit me. Feeds the "Not yet specified" fog in the
Trailblazer map (`../README.md`).

NOTE: This `itj-daemon-tinydeps.md` file was retroactively generated using AI,
long after the original `itj_daemon/issues/59` map session was ~abandoned. Much
of this `itj-daemon-tinydeps.md` misses the point, and could even be flat-out
wrong. e.g. "7. The prototype skill's code branch wasn't used":

* It has the timeline wrong:

  * The very first draft of `CODE.md` is dated Oct. 5th:

    https://github.com/Ivan-Johnson/itj-mattpocock-skills/commit/20365ca

  * The referenced "prototype" was dated Oct. 4th:

    https://github.com/Ivan-Johnson/itj_daemon/issues/68#issuecomment-5985732276

    https://github.com/Ivan-Johnson/TinyDeps/blob/222ac7e6c49e8082e3214c674df417b05ce91d56/itj_rpc_macro/src/lib.rs

* I wouldn't really call it a "prototype"; it's intended to be on `mainline`.

## Context

- Dates: 2026-09-30 (handoff doc) to 2026-10-31 (last TinyDeps commit in scope). The map was last edited 2026-10-04.
- Repos: `Ivan-Johnson/itj_daemon` (the map and its tickets) and `Ivan-Johnson/TinyDeps` (where the work actually happened).
- Map: [Map: split Dispatcher into independent domain plugins + shared cross-plugin IPC routing](https://github.com/Ivan-Johnson/itj_daemon/issues/59). Destination: split the monolithic `Dispatcher` into independent `Plugin`s (`IpcPlugin`, `Controller`, `SttEngine`, `NightlyShutdownScheduler`), one connection at a time, no cross-tick deferral. Planning only.
- Skill chain before the map: `/grill-with-docs` on issue #4, a handoff doc (`handoff-itj-daemon-issue-4-rpc-redesign.md`), `/ask-matt`, then `/wayfinder` (chart).
- Tickets: #60 connection correlation (closed by scope change), #67 capture the old handoff doc (closed), #68 per-operation type safety (closed), #61 loop location (open), #62 `Plugin` shape per domain (open).
- Outputs: a TinyDeps RPC stack (`itj_rpc_macro`: `#[define_rpc]`, `define_proxy_rpc!`; `itj_tiny_ipc`: `RpcBundle`; two ADRs). `itj_daemon` itself is unchanged: `dispatcher.rs` is still monolithic and has not been touched since 2026-09-30.
- Session ID of the #68 resolution session: 3199ca10-4e07-44ca-ab9c-65b833928bab.

## Timeline

All times 2026-10-04 unless noted. Issue times are UTC and commit times are local (EDT, UTC-4).

1. 09-30: handoff doc. A `/grill-with-docs` session on issue #4 had grown from "extract a shared accept/route loop" into "split `Dispatcher` and build a queueing router". One hole was already known (reply-to-connection correlation).
2. 16:09 UTC: map and #60 created. #4 closed as superseded.
3. 17:30 UTC: #60 resolved by cutting scope (one connection, no cross-tick deferral). The destination was rewritten to match.
4. 17:31 UTC: #61 and #62 created.
5. 17:39 to 18:00 UTC: sub-issue mechanics test (throwaway issues #63 to #66, since closed).
6. 18:26 UTC: #67 created and closed within minutes.
7. 18:34 UTC: #68 created. 15:33 local: first macro commit (`f3713bd`).
8. 15:33 to 19:31 local: `itj_rpc_macro` written by hand, outside any agent session, as a spike against real trait shapes.
9. 19:48 local (23:48 UTC): `/wayfinder` session. The first prompt was "I've just created `itj_rpc_macro/src/lib.rs`. Which sub-issue(s) of #59 do we need to update?" The agent picked #68, and it was claimed, resolved against commit `222ac7e` and closed. The map's Decisions-so-far was updated. No ticket was worked at the map level.
10. 22:16 to 23:05 local: macro work continued after the ticket was closed (generated dispatcher, serde derives, wiring `itj_daemon_hello_world` to it).
11. 10-05: macro grew generated clients and servers, and multi-connection support (`8674e2d`, 16:33).
12. 10-16 to 10-31: proxy POC, `Endpoint`/`Local`/`Remote`, `RpcBundle`, `define_proxy_rpc!`, ADRs 0001 and 0002.
13. 10-04 onward: no more map edits. #61 and #62 are still open and unclaimed.

## Expected versus actual

- Expected: a small map would take the redesign past the scope explosion, with the hard calls recorded and the build following soon after.
- Actual: the map was used as a ledger. The one real decision (#68) was made by building, and then recorded. The build then continued outside the map for weeks, and I didn't update the map.

## Bites

1. **Charting felt like overhead, so the trail got blazed instead.** I stopped updating the map because building was more useful. That is my own choice, not a limitation of `/wayfinder`. The plan is to return to the map and update it once the TinyDeps work is done, then implement the `itj_daemon` changes.
2. **The map was used after the fact.** The #68 session started from existing code and asked "which ticket does this belong to?" The decision was reconstructed from the code rather than reached through the ticket.
3. **The map's scoping was shaped to get to implementation quickly, and later contradicted.** "One connection at a time" was kept deliberately small. About 18 hours later, `8674e2d` added multi-connection support. The commit deleted a TODO written 8 minutes earlier (`0ecb5f9`: "use a Vec instead of an Option (or a fixed size array?)"). I don't remember whether this was deliberate or manual. My best guess: the scope was kept small to start building, and once I abandoned the map and had a minimal prototype, I was free to do more. The map was never updated.
4. **The #68 resolution links a commit that the macro then moved past.** It links `222ac7e`, but the macro changed substantially afterwards. The map's description (`dispatch_<trait>` per trait) is out of date compared with `Endpoint`/`Local`/`Remote`, `RpcBundle` and `define_proxy_rpc!`.
5. **Tickets were mis-typed or didn't fit.** #62 is labelled `grilling` but its questions (`Rc<RefCell>` sharing, generic bounds on `Controller`) can only be answered against real code. #67 was a reading chore and unblocked no decision. The sub-issue mechanics test left noise issues.
6. **#61 and #62 depend on #68, and #68 grew much bigger than a spike.**
~~7. **The prototype skill's code branch wasn't used.** The spike was written directly on mainline in `itj_rpc_macro/src/lib.rs`, and neither repo has the `docs/prototypes.md` that the code-prototype overlay (`itj-mattpocock-skills`, `CODE.md`) requires. The overlay exists to answer exactly this kind of question (does this signature work against real types).~~

## What worked

- The handoff doc and the map gave a clean reset after the scope explosion. Cutting multi-connection and cross-tick deferral dissolved the correlation problem.
- The #68 spike produced a real, reviewable artefact and a decision with a pinned commit link. The later ADRs capture the follow-on design.
- The macro work compounded: small tested commits, trybuild UI tests, ADRs.

## Counter-evidence (against a new skill)

- The map's Notes could have said "carry execution into the map", and a destination of "working `IpcPlugin` end to end" would have fitted that better than "plan the split".
- A single-session handoff plus `/grill-with-docs` or `/to-spec` might have been enough for the original problem. I used `/ask-matt` before charting and still picked `/wayfinder`.
- I still don't understand which problems need `/wayfinder` and which don't.

## Signals for the open questions

- Separate skill versus a recipe: not enough here to say. I abandoned the map's mechanics rather than bending them, but that was my choice, and a Notes override might have worked.
- Several decisions were answered only by running code (type shapes, generics, object safety), which is what the code-prototype overlay is for.
- Neither instance says what a "done" state looks like without a cleared map; that stays open.

## Pointers

- Map: https://github.com/Ivan-Johnson/itj_daemon/issues/59
- #68 resolution: https://github.com/Ivan-Johnson/itj_daemon/issues/68
- Old design issue (superseded): https://github.com/Ivan-Johnson/itj_daemon/issues/4
- TinyDeps macro (as of the #68 resolution): https://github.com/Ivan-Johnson/TinyDeps/blob/222ac7e6c49e8082e3214c674df417b05ce91d56/itj_rpc_macro/src/lib.rs
- ADRs: `TinyDeps/docs/adr/0001-rpcbundle-dyn-trait-compile-time-lookup.md` and `0002-endpoint-local-remote-marker-traits.md`
- Handoff doc: `~/Workspaces/7/handoff-itj-daemon-issue-4-rpc-redesign.md`
- Prototype overlay: `~/Workspaces/5/DotFiles/itj-mattpocock-skills/overlay/skills/engineering/prototype/`
