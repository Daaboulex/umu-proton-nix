# Design

Why the packaging is built the way it is. The [README](../README.md) says how
to use it.

## Upstream

| What | Value |
|---|---|
| Project | [Open-Wine-Components/umu-proton](https://github.com/Open-Wine-Components/umu-proton) |
| License | BSD-3-Clause (Valve Proton lineage) |
| Tracked | GitHub releases (`UMU-Proton*` tags, daily) |

## What the flake carries

The flake fetches the prebuilt UMU-Proton release tarballs and exposes them as
two-output packages (`out` + `steamcompattool`) in the nixpkgs `proton-ge-bin`
shape, so they drop straight into `programs.steam.extraCompatPackages` or a
`PROTONPATH`.

The packages are built by the fleet standard's `steamCompatTool`, so this flake
carries only upstream's facts: the tag, the assets and their hashes, the brand
and the major line. The tag and the assets are in [sources.nix](../sources.nix),
the brand is in [flake.nix](../flake.nix), and the major line is `majorPattern`
in [.github/update.json](../.github/update.json).

## Asset names

| Releases | Assets |
|---|---|
| up to UMU-Proton-10.0-4 | `<tag>.tar.gz`, x86_64 only |
| from UMU-Proton-11.0-2e | `<tag>-x86_64.tar.gz` and `<tag>-aarch64.tar.gz` |

- The updater writes each asset of the rolling release as its URL with its
  hash, so the build fetches the file the updater hashed, whatever its name.
- A pin that holds a bare hash takes its URL from `assetUrl` in
  [flake.nix](../flake.nix), which builds the old `<tag>.tar.gz` name.

## The two attributes

| Attribute | What it is | System |
|---|---|---|
| `umu-proton` (`pkgs.umu-proton`) | the host's own build: the x86_64 asset on `x86_64-linux`, the aarch64 asset on `aarch64-linux` | both |
| `umu-proton-x86_64` (`packages.default`) | the x86_64 tarball on a host of either architecture, for an x86 Steam client running under FEX on aarch64; on `x86_64-linux` the same derivation as `umu-proton` | both |

## Why UMU-Proton next to GE-Proton

Unlike GE-Proton, UMU-Proton carries no wine-staging or protonify patch set:
its wine is Valve's submodule pin plus a small enumerated hotfix list, which
makes it the clean A/B arm when a GE patch class is suspected in a regression.

## Channels

Every channel is a passthru of the tool attribute (`pkgs.umu-proton.v9`), never
a top-level package. `latest` follows upstream's newest release; each
`v<major>` is a line: the rolling line's channel follows its newest release and
shows as a pin, a closed line's channel is its last release.

When upstream opens a new major, the daily updater pins the outgoing release by
itself (`majorPattern` in [.github/update.json](../.github/update.json)), so no
channel vanishes and nobody edits a hash by hand.

## The two names in each vdf

Each channel's `compatibilitytool.vdf` carries two names.

The key, what Steam saves for a game's choice, is the attribute and the channel
and never moves, so a choice survives every update. For this flake the keys
read `umu-proton-latest` and `umu-proton-v9`.

The display name, what the dropdown shows, is
`UMU-Proton <major> (<build>, latest)` for the rolling channel and
`UMU-Proton <major> (<build>)` for a pin, so it says which release runs.
