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
      url = "github:Daaboulex/nix-packaging-standard/release";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      toolsFor =
        pkgs:
        inputs.std.lib.steamCompatTool {
          inherit pkgs;
          attribute = "umu-proton";
          brand = "UMU-Proton";
          homepage = "https://github.com/Open-Wine-Components/umu-proton";
          description = "UMU-Proton prebuilt Steam Play compatibility tool, stock Valve Proton for umu-launcher";
          license = pkgs.lib.licenses.bsd3;
          sources = import ./sources.nix;
          inherit (pkgs.lib.importJSON ./.github/update.json) majorPattern;
          buildOf = tag: pkgs.lib.head (builtins.match "[A-Z]+-Proton-[0-9]+\\.[0-9]+-(.*)" tag);
          assetUrl =
            tag: _token:
            "https://github.com/Open-Wine-Components/umu-proton/releases/download/${tag}/${tag}.tar.gz";
          variantsOf = release: {
            x86_64 = release.hashX64;
          };
          tokens.x86_64 = {
            system = "x86_64-linux";
            suffix = "";
            qualifier = null;
          };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.std.flakeModules.base ];

      perSystem =
        { pkgs, ... }:
        let
          umu = toolsFor pkgs;
        in
        {
          packages = umu.tools // {
            default = umu.tools.umu-proton-x86_64;
          };
          checks.compat-tool-shape = umu.checks.compat-tool-shape;
        };

      flake.overlays.default = final: _prev: (toolsFor final).tools;
    };
}
