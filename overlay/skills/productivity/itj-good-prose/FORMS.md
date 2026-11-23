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

For a form not listed, name who the reader is, what they know, and what they
want before writing.

## Inline comments

* **Gate:** add a comment only when it carries a *why* or a *footgun*. Simple
  code gets none; what counts as simple depends on context (a linker script
  needs more than plain C).
* **The *footgun*:** what breaks if someone makes the obvious-looking change.
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

## ADRs

Format and location come from the `domain-modeling` skill. In the text, state
the decision, the forces behind it, and what was given up.

## Commit messages and PR bodies

The PR template comes from the `pr` skill. The subject states the change; the
body states the *why* and the risk, since the diff already shows the *what*.
Evidence for what a commit adds, and the reason for what it cuts, belongs in
the body.
