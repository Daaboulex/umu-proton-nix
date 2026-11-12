# Development

The flake follows `nixos-unstable` and builds for `x86_64-linux` and
`aarch64-linux`.

## Checks

```bash
nix flake check
```

`checks.compat-tool-shape` builds every channel and reads each vdf for the key
and display formats.

`checks.overlay-applies` compares what `overlays.default` yields with the
flake's own packages.

Both come from the fleet standard's `steamCompatTool`, which
[flake.nix](../flake.nix) calls.

## Updates

The rolling release and the pinned releases are in
[sources.nix](../sources.nix), which the daily updater moves.

[.github/update.json](../.github/update.json) tells the updater what to follow:
the GitHub releases of `Open-Wine-Components/umu-proton` whose tag starts with
`UMU-Proton`. The hash it rewrites is `hashX64`.

When upstream opens a new major, the updater pins the outgoing release by
itself. `majorPattern` in the same file names the major line. The updater edits
between the `std:` marker lines in `sources.nix`, so they stay where they are.

## Workflows

| Workflow | What it does | When |
|---|---|---|
| [ci.yml](../.github/workflows/ci.yml) | Runs the standard's package CI | On a push to `main` or `master`, on a pull request, by hand |
| [update.yml](../.github/workflows/update.yml) | Runs the updater | Daily, unless the repository variable `UPDATE_CADENCE` says otherwise |
| [maintenance.yml](../.github/workflows/maintenance.yml) | Runs the standard's maintenance | Weekly, unless the repository variable `MAINTENANCE_CADENCE` says otherwise |

Each one calls a reusable workflow from `Daaboulex/nix-packaging-standard` at
its `release` branch.
