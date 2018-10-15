{ pkgs ? import ./pkgs.nix }:

with pkgs;

let
  hex = fetchurl {
    url = "https://repo.hex.pm/installs/1.6.0/hex-0.18.1.ez";
    sha512 = "9c806664a3341930df4528be38b0da216a31994830c4437246555fe3027c047e073415bcb1b6557a28549e12b0c986142f5e3485825a66033f67302e87520119";
  };
in

(callPackage (mixToNix ./.) {}).overrideAttrs (oldAttrs: rec {
  name = "educator_aaa";
  version = "0.0.1";

  buildPhase = ''
    runHook preBuild

    mix archive.install --force ${hex}
    mix release --env=prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    tar -xzf _build/prod/rel/${name}/releases/${version}/${name}.tar.gz -C $out

    runHook postInstall
  '';
})
