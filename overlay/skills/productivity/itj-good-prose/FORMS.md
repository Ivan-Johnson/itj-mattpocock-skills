# Forms

Reader and rules per form. The standard in [`SKILL.md`](SKILL.md) applies to
all of them.

| Writing | Reader | Already knows | Wants |
|---|---|---|---|
| Inline comment | Maintainer editing this code | The codebase | The *why*, the *footgun* |
| Doc comment | Caller of this function or module | Little of the module | The *contract*: when and how to use it |
| README | Newcomer | Nothing | Is this what I need? How do I start? |
| ADR | Future maintainer | The codebase as it is now | Why it is this way; what was given up |
| Commit message | Reviewer; later `git blame` reader | The diff | Why this change; its risk |
| PR body | Reviewer | The repo, not this change | What changed; evidence; risk |
| Message (Slack, email, ticket or CR comment) | A named person or channel | Their own work, rarely yours | What you need from them, and why now |

For a form not listed, name who the reader is, what they know, and what they
want before writing.

## Inline comments

* **Gate:** add a comment only when it carries a *why* or a *footgun*. Simple
  code gets none; what counts as simple depends on context (a linker script
  needs more than plain C).
* **The *footgun*:** what breaks if someone makes the obvious-looking change.
* **No-op:** a comment that restates what a flag or name already says adds
  nothing; add one only for what the name does not carry.
* **Shape:** typically under ~30 words and ~two lines. Complete sentences once
  prose spans multiple lines; a one-line comment can be a fragment.

## Doc comments

* State the *contract*: what it returns, what it requires, what varies between
  calls, and when to use it over the alternatives.
* Put how it's computed in a `//` comment in the body.

## READMEs

* Open with what the project is and who it's for, then the shortest path to
  first use.
* Link deeper docs rather than inlining them.
* A README edited often holds too much detail: move the part that keeps
  changing into the doc it describes.

## ADRs

Format and location come from the `domain-modeling` skill. In the text, state
the decision, the forces behind it, and what was given up.

## Commit messages and PR bodies

The PR template comes from the `pr` skill. The subject states the change; the
body states the *why* and the risk, since the diff already shows the *what*.
Evidence for what a commit adds, and the reason for what it cuts, belongs in
the body.

## Messages

Return three things, in order: the **outcome** (what happens after the
reader reads it, ideally), the **audience** (who must act, who only needs
to know, and where each already follows the topic), and the **draft**, in a
fenced code block so its raw markdown survives the chat UI. The draft is
done when:

* It goes where the conversation already lives, once per recipient. A
  recipient who can already read the message's news or ask elsewhere (a
  channel they are in, a thread they follow) gets a one-line pointer to
  it, or nothing.
* Its asks, if any, serve the outcome, and each says who acts. An FYI
  needs none.
* It answers the question the reader asked, and nothing they didn't ask;
  proof of an unquestioned claim and unrequested commitments are cut.
* Every factual claim, and every claim it implies (such as "this is small"),
  is checked against its source. A claim about another ticket's or CR's
  status links the latest comment that states it.
* A reason given for urgency is the real one, with its date and owner;
  a placeholder or vague "soon" is not.
* It fits the reader's norms: their SLA, what they already declined, an
  easy no. One clear ask beats several.
* Every term is the reader's, not this session's.
