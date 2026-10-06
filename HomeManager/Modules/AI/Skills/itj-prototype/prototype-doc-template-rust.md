# Prototypes

Where throwaway code prototypes live in this project, and how they are built.

## Location

`prototypes/<name-of-prototype>/` at the project's top level, one self-contained cargo crate per
prototype, each added as a workspace member.

## Build and check

The default check command (`cargo check --all-features`) compiles every prototype. Prototypes only
exist behind the `prototype` feature, so they are inert under a plain default check and the
prototypes' code never reaches a normal build.

A prototype must not be used as a dependency of any other crate. The check compiles a prototype,
but nothing links it into the primary build target.

## Independence

A prototype depends only on the project's real crates (as path dependencies) and the standard
library. One prototype must not depend on another: if it needs a type from a sibling prototype,
ask the user to merge the two prototypes, or, when the user can't be reached, copy the code.

## Naming

Name the crate directory for the question being answered: `prototypes/<short-question-slug>/`.

## Lifecycle

A prototype lives until its question is answered, then can be deleted; git history keeps it
recoverable.
