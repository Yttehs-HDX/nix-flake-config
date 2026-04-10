{ input }:
{ lib, ... }:
let softwareModules = import ./software/default.nix { inherit lib input; };
in {
  imports = softwareModules;

  home.username = input.identity.name;
  home.homeDirectory = input.identity.homeDirectory;
  home.stateVersion = input.state.home.stateVersion;

  programs.home-manager.enable = true;
}
