# itj-mattpocock-skills

[mattpocock/skills](https://github.com/mattpocock/skills) with my changes
applied on top, as a Nix flake. Instead of merging upstream into a fork, the
flake takes upstream as an input and builds `packages.<system>.default`:

* `patches/*.patch`: changes to upstream files, applied with `patch -p1`.
* `overlay/`: new files, copied over the upstream tree.

The build fails if a patch stops applying, or if upstream adds a file that
`overlay/` also provides. Fix it here when that happens.

Consumers should make this flake's `mattpocock_skills` input follow their own,
so `nix flake update` in the consumer pulls the latest upstream:

```nix
mattpocock_skills = {
        url = "github:mattpocock/skills";
        flake = false;
};
itj_mattpocock_skills = {
        url = "github:Ivan-Johnson/itj-mattpocock-skills";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.mattpocock_skills.follows = "mattpocock_skills";
};
```

## Editing a patch

```sh
src=$(nix eval --raw .#default.src)
cp -r --no-preserve=mode "$src" /tmp/upstream
cp -r --no-preserve=mode "$src" /tmp/patched
(cd /tmp/patched && patch -p1 < "$OLDPWD/patches/<name>.patch")
# edit /tmp/patched, then:
(cd /tmp && diff -ruN upstream patched) > patches/<name>.patch
```
