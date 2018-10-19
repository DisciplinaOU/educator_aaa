{ pkgs ? import ./pkgs.nix }:

with pkgs;

let
  hex = pkgs.beam.packages.erlang.hex;
in

(callPackage (mixToNix ./.) {}).overrideAttrs (oldAttrs: rec {
  name = "educator_aaa";
  version = "0.0.1";

  buildInputs = oldAttrs.buildInputs ++ [ hex ];

  buildPhase = ''
    runHook preBuild

    addToSearchPath MIX_PATH "${hex}/lib/erlang/lib/"
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
