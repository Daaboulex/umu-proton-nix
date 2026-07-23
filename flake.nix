{
  description = "UMU-Proton packaged for NixOS - stock Valve Proton for umu-launcher, rolling latest plus pinned channels, tracking upstream daily";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:Daaboulex/nix-packaging-standard?ref=v2.12.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ inputs.std.flakeModules.base ];

      perSystem =
        { pkgs, lib, ... }:
        let
          assembled = pkgs.callPackage ./default.nix { };
        in
        {
          packages = {
            default = assembled.umu-proton;
          }
          // assembled.channels;

          checks.compat-tool-shape =
            let
              named = lib.mapAttrsToList (n: drv: {
                inherit n;
                tool = drv.steamcompattool;
                ver = drv.version;
              }) assembled.channels;
            in
            pkgs.runCommand "umu-proton-shape" { } ''
              ${lib.concatMapStringsSep "\n" (c: ''
                echo "checking channel ${c.n} (${c.ver})"
                test -e "${c.tool}/proton"
                test -f "${c.tool}/compatibilitytool.vdf"
                grep -q '"UMU-Proton' "${c.tool}/compatibilitytool.vdf"
                if grep -qF "${c.ver}" "${c.tool}/compatibilitytool.vdf"; then
                  echo "versioned identity ${c.ver} leaked into channel ${c.n}'s vdf" >&2
                  exit 1
                fi
              '') named}
              touch "$out"
            '';
        };

      flake.overlays.default = final: _prev: {
        umu-proton = (final.callPackage ./default.nix { }).umu-proton;
      };
    };
}
