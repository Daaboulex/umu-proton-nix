# umu-proton-nix

UMU-Proton packaged for NixOS: stock Valve Proton rebuilt by the Open Wine
Components project to run without Steam via umu-launcher, delivered as a Steam
Play compatibility tool with a stable dropdown identity.

Channels mirror the proton-ge-nix model: `latest` follows the newest upstream
release under the version-free name "UMU-Proton"; each pinned major in
`sources.nix` gets a `v<major>` channel named "UMU-Proton <major>". The
`steamcompattool` output drops into `programs.steam.extraCompatPackages` or a
`PROTONPATH`.

Unlike GE-Proton, UMU-Proton carries no wine-staging or protonify patch set:
its wine is Valve's submodule pin plus a small enumerated hotfix list, which
makes it the clean A/B arm when a GE patch class is suspected in a regression.

```nix
inputs.umu-proton.url = "github:Daaboulex/umu-proton-nix";

programs.steam.extraCompatPackages = [ pkgs.umu-proton.steamcompattool ];
```

Updates are automated from upstream GitHub releases via `.github/update.json`
on the nix-packaging-standard workflow set.
