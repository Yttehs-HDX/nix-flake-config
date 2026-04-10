{ input }:
{ lib, ... }:
let packageModules = import ./packages/default.nix { inherit lib input; };
in {
  imports = packageModules;

  home.username = input.identity.name;
  home.homeDirectory = input.identity.homeDirectory;
  home.stateVersion = input.state.home.stateVersion;

  programs.home-manager.enable = true;
}
