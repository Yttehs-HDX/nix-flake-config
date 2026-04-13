{ ... }:
{ pkgs, inputs, ... }:
let system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages =
    [ inputs.nur.legacyPackages.${system}.repos.zerozawa.mikusays ];
}
