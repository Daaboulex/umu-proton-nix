# umu-proton (Nix)

<!-- BEGIN generated:badges -->
[![CI](https://github.com/Daaboulex/umu-proton-nix/actions/workflows/ci.yml/badge.svg)](https://github.com/Daaboulex/umu-proton-nix/actions/workflows/ci.yml)
[![NixOS unstable](https://img.shields.io/badge/NixOS-unstable-78C0E8?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
<!-- END generated:badges -->

Nix flake packaging for [UMU-Proton](https://github.com/Open-Wine-Components/umu-proton) by [Open Wine Components](https://github.com/Open-Wine-Components) - stock Valve Proton rebuilt to run without Steam via umu-launcher.

<!-- BEGIN generated:upstream -->
## Upstream

| | |
|---|---|
| **Project** | [Open-Wine-Components/umu-proton](https://github.com/Open-Wine-Components/umu-proton) |
| **License** | BSD-3-Clause (Valve Proton lineage) |
| **Tracked** | GitHub releases (`UMU-Proton*` tags, daily) |

<!-- END generated:upstream -->

## What Is This?

A Nix flake that fetches the prebuilt UMU-Proton release tarballs and exposes them as two-output packages (`out` + `steamcompattool`) in the nixpkgs `proton-ge-bin` shape, so they drop straight into `programs.steam.extraCompatPackages` or a `PROTONPATH`. The packages are built by the fleet standard's `steamCompatTool`, so this flake carries only upstream's facts: the tag, the asset hash, the brand and the major line.

Upstream ships one x86_64 tarball per release and no aarch64 build:

| Attribute | What it is | System |
|---|---|---|
| `umu-proton` (`pkgs.umu-proton`) | the host's own build | `x86_64-linux` |
| `umu-proton-x86_64` (`packages.default`) | the x86_64 tarball on a host of either architecture, for an x86 Steam client running under FEX on aarch64; on `x86_64-linux` the same derivation as `umu-proton` | both |

Unlike GE-Proton, UMU-Proton carries no wine-staging or protonify patch set: its wine is Valve's submodule pin plus a small enumerated hotfix list, which makes it the clean A/B arm when a GE patch class is suspected in a regression.

## Channels

Every channel is a passthru of the tool attribute (`pkgs.umu-proton.v9`), never a top-level package. `latest` follows upstream's newest release; each `v<major>` is a line: the rolling line's channel follows its newest release and shows as a pin, a closed line's channel is its last release. When upstream opens a new major, the daily updater pins the outgoing release by itself (`majorPattern` in [`.github/update.json`](./.github/update.json)), so no channel vanishes and nobody edits a hash by hand.

Each channel's `compatibilitytool.vdf` carries two names. The key, what Steam saves for a game's choice, is the attribute and the channel and never moves, so a choice survives every update. The display name, what the dropdown shows, is `UMU-Proton <major> (<build>, latest)` for the rolling channel and `UMU-Proton <major> (<build>)` for a pin, so it says which release runs.

The rolling release and the pinned releases are in [`sources.nix`](./sources.nix), which the daily updater moves.

<!-- BEGIN generated:installation -->
## Installation

Add as a flake input:

```nix
{
  inputs.umu-proton = {
    url = "github:Daaboulex/umu-proton-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then either take the package directly:

```nix
programs.steam.extraCompatPackages = [
  inputs.umu-proton.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

or apply `inputs.umu-proton.overlays.default` and use `pkgs.umu-proton`.

<!-- END generated:installation -->

## Usage

```nix
programs.steam = {
  enable = true;
  extraCompatPackages = [
    pkgs.umu-proton
    pkgs.umu-proton.v9
  ];
};
```

Steam lists both in each game's Compatibility dropdown, under the display names the Channels section gives, and umu-launcher accepts `PROTONPATH = "${pkgs.umu-proton.steamcompattool}"` directly. `checks.compat-tool-shape` builds every channel and reads each vdf for the key and display formats.

## License

The packaging is MIT. UMU-Proton itself is upstream's license (Valve Proton BSD-3-Clause lineage plus bundled components); this flake redistributes nothing - tarballs are fetched from upstream's GitHub releases at build time.

<!-- BEGIN generated:footer -->
<!-- END generated:footer -->
