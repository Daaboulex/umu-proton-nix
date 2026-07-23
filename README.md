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

A Nix flake that fetches the prebuilt UMU-Proton release tarballs and exposes them as two-output packages (`out` + `steamcompattool`) in the nixpkgs `proton-ge-bin` shape, so they drop straight into `programs.steam.extraCompatPackages` or a `PROTONPATH`.

Channels mirror the proton-ge-nix model: `latest` follows the newest upstream release under the rolling identity `UMU-Proton-latest`; each pinned release in `sources.nix` gets a `v<major>` channel named `UMU-Proton <version>` (Steam's exact-version style). A game mapped to `UMU-Proton-latest` rides every update; one mapped to a pin stays on that exact build.

Unlike GE-Proton, UMU-Proton carries no wine-staging or protonify patch set: its wine is Valve's submodule pin plus a small enumerated hotfix list, which makes it the clean A/B arm when a GE patch class is suspected in a regression.

- **Package integrity** - SRI source hashes, verified on every build
- **CI security** - pinned GitHub Actions (full SHA, not tags), minimal permissions, build-gated PRs
- **Upstream trust** - daily automated release detection, hash recomputation, and a verified test build, auto-committed to `main`
- **Stale cleanup** - weekly `flake.lock` refresh (pushed only if it still builds); orphaned update branches older than 30 days are deleted

## Channels

Current pins as of 2026-07-23; the live truth is `sources.nix` (updated daily).

| Attribute | Steam identity | Version |
|---|---|---|
| `latest` (`packages.default`, `pkgs.umu-proton`) | `UMU-Proton-latest` | UMU-Proton-10.0-4 |
| `v10` | `UMU-Proton 10.0-4` | UMU-Proton-10.0-4 |
| `v9` | `UMU-Proton 9.0-4e` | UMU-Proton-9.0-4e |

`latest` rolls with every upstream release; each `v<major>` is a frozen pin on
that major's newest packaged release.

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
  inputs.umu-proton.packages.${pkgs.system}.default
];
```

or apply `inputs.umu-proton.overlays.default` and use `pkgs.umu-proton`.

<!-- END generated:installation -->

## Usage

```nix
programs.steam = {
  enable = true;
  extraCompatPackages = [ pkgs.umu-proton ];
};
```

Steam lists `UMU-Proton-latest` (plus each pinned major, e.g. `UMU-Proton 9.0-4e`) in each game's Compatibility dropdown, and umu-launcher accepts `PROTONPATH = "${pkgs.umu-proton.steamcompattool}"` directly. Pinning an older release is nix-native: use its frozen per-major channel - `pkgs.umu-proton.v9` after the overlay, or `inputs.umu-proton.packages.${pkgs.system}.v9`.

## License

The packaging is MIT. UMU-Proton itself is upstream's license (Valve Proton BSD-3-Clause lineage plus bundled components); this flake redistributes nothing - tarballs are fetched from upstream's GitHub releases at build time.

<!-- BEGIN generated:footer -->
---

*Maintained as part of the [Daaboulex](https://github.com/Daaboulex) NixOS ecosystem.*
<!-- END generated:footer -->
