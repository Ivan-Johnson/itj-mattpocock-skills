{
        description = "mattpocock/skills with Ivan's changes applied on top";

        inputs = {
                nixpkgs.url = "nixpkgs/nixos-26.05";

                mattpocock_skills = {
                        url = "github:mattpocock/skills";
                        flake = false;
                };
        };

        outputs =
                {
                        self,
                        nixpkgs,
                        mattpocock_skills,
                }:
                let
                        forAllSystems = nixpkgs.lib.genAttrs [
                                "x86_64-linux"
                                "aarch64-linux"
                                "x86_64-darwin"
                                "aarch64-darwin"
                        ];
                in
                {
                        # The upstream tree with `patches/*.patch` applied and `overlay/` copied on top.
                        # Fails to build if a patch no longer applies or an overlay file now exists
                        # upstream, so upstream changes that conflict with ours can't be missed.
                        packages = forAllSystems (
                                system:
                                let
                                        pkgs = nixpkgs.legacyPackages.${system};
                                in
                                {
                                        default = pkgs.applyPatches {
                                                name = "itj-mattpocock-skills";
                                                src = mattpocock_skills;
                                                patches = map (name: ./patches + "/${name}") (builtins.attrNames (builtins.readDir ./patches));
                                                postPatch = ''
                                                        cd ${./overlay}
                                                        for f in $(find . -type f); do
                                                                if [ -e "$OLDPWD/$f" ]; then
                                                                        echo "overlay file $f already exists upstream; move the change into a patch" >&2
                                                                        exit 1
                                                                fi
                                                        done
                                                        cd "$OLDPWD"
                                                        cp -r --no-preserve=mode ${./overlay}/. .
                                                '';
                                        };
                                }
                        );
                };
}
