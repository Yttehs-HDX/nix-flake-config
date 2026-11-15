{ inputs, pkgs }:

inputs.latchshot.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ./niri-edge-at-output-boundary.patch ];
})
