{
  pkgs,
  lib ? pkgs.lib,
}:
let
  sources = import ./sources.nix;

  majorOf = tag: lib.head (builtins.match "UMU-Proton-([0-9]+)\\..*" tag);

  allReleases = {
    ${sources.version} = {
      inherit (sources) hashX64;
    };
  }
  // sources.pins;

  mk =
    tag: steamDisplayName:
    pkgs.callPackage ./package.nix {
      inherit tag steamDisplayName;
      hashX64 = allReleases.${tag}.hashX64;
    };

  latestDrv = mk sources.version "UMU-Proton";

  majorChannels = lib.listToAttrs (
    map (tag: {
      name = "v${majorOf tag}";
      value = mk tag "UMU-Proton ${majorOf tag}";
    }) (lib.attrNames allReleases)
  );

  channels = majorChannels // {
    latest = latestDrv;
  };
in
{
  umu-proton = latestDrv.overrideAttrs (old: {
    passthru = (old.passthru or { }) // channels;
  });
  inherit channels;
}
