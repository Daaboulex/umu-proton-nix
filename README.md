# umu-proton (Nix)

[UMU-Proton](https://github.com/Open-Wine-Components/umu-proton) by
[Open Wine Components](https://github.com/Open-Wine-Components), packaged as a
Nix flake. UMU-Proton is stock Valve Proton rebuilt to run without Steam via
umu-launcher. The packages go into `programs.steam.extraCompatPackages` or a
`PROTONPATH`.

Unlike GE-Proton, UMU-Proton carries no wine-staging or protonify patch set.
Its wine is Valve's submodule pin plus a small enumerated hotfix list. That
makes it the clean side of an A/B comparison when a GE patch class is suspected
in a regression.

The flake fetches upstream's prebuilt release tarballs and compiles nothing.
Its check builds every channel and reads each `compatibilitytool.vdf`, but it
does not start a game. This repository records no game run on either
architecture.

## What you get

Upstream ships one x86_64 tarball per release and no aarch64 build.

- `umu-proton` is the host's own build. It exists on `x86_64-linux` only.
- `umu-proton-x86_64` is the x86_64 tarball on a host of either architecture.
  On aarch64 it is for an x86 Steam client running under FEX. On
  `x86_64-linux` it is the same derivation as `umu-proton`.

`umu-proton-x86_64` is the flake's default package on both systems. Each
package has two outputs, `out` and `steamcompattool`, in the shape of nixpkgs'
`proton-ge-bin`.

## Install

Add the flake:

```nix
{
  inputs.umu-proton = {
    url = "github:Daaboulex/umu-proton-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then hand the package to Steam:

```nix
programs.steam.extraCompatPackages = [
  inputs.umu-proton.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

Or apply `inputs.umu-proton.overlays.default` and use `pkgs.umu-proton`. On
aarch64 the overlay provides `pkgs.umu-proton-x86_64` instead.

## Use

With the overlay applied, on `x86_64-linux`:

```nix
programs.steam = {
  enable = true;
  extraCompatPackages = [
    pkgs.umu-proton
    pkgs.umu-proton.v9
  ];
};
```

Steam lists both in each game's Compatibility dropdown. umu-launcher accepts
the tool directly:

```nix
PROTONPATH = "${pkgs.umu-proton.steamcompattool}";
```

## Channels

A channel is reached through the tool attribute, as in `pkgs.umu-proton.v9`.
It is never a top-level package.

| Channel | What it follows |
|---|---|
| `latest` | Upstream's newest release. The attribute itself is this channel. |
| `v<major>` | One major line. A closed line stays at its last release. |

The line upstream is still releasing has a `v<major>` channel too. It follows
that line's newest release and shows as a pin.

In the dropdown the rolling channel reads `UMU-Proton <major> (<build>, latest)`
and a pin reads `UMU-Proton <major> (<build>)`, so the name says which release
runs. A game's choice of channel survives every update.

The releases behind the channels are in [sources.nix](sources.nix), which a
daily updater moves.

## Known limits

- Upstream has no aarch64 build. On aarch64 the only package is the x86_64
  tarball, which is for an x86 Steam client running under FEX.
- The `out` output holds only a note. A path to the tool, such as a
  `PROTONPATH`, takes the `steamcompattool` output.
- A closed major line keeps one release, its last.

## More

- [docs/DESIGN.md](docs/DESIGN.md): how the packages are built, the two names
  in each `compatibilitytool.vdf`, what happens when upstream opens a new major
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md): the checks, the daily updater,
  the workflows
- [SECURITY.md](SECURITY.md): how to report a vulnerability

## License

The packaging is MIT. UMU-Proton itself is upstream's license (Valve Proton
BSD-3-Clause lineage plus bundled components); this flake redistributes
nothing. Tarballs are fetched from upstream's GitHub releases at build time.
