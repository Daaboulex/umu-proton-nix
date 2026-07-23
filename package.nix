{
  lib,
  stdenvNoCC,
  fetchzip,
  tag,
  hashX64,
  steamDisplayName ? "UMU-Proton",
}:
stdenvNoCC.mkDerivation {
  pname = "umu-proton";
  version = tag;

  src = fetchzip {
    url = "https://github.com/Open-Wine-Components/umu-proton/releases/download/${tag}/${tag}.tar.gz";
    hash = hashX64;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall
    echo "umu-proton is a Steam compatibility tool; consume the steamcompattool output via programs.steam.extraCompatPackages." > $out
    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "${tag}" "${steamDisplayName}"
    runHook postInstall
  '';

  meta = {
    description = "UMU-Proton prebuilt Steam Play compatibility tool (${tag}), stock Valve Proton for umu-launcher, stable dropdown identity";
    homepage = "https://github.com/Open-Wine-Components/umu-proton";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
