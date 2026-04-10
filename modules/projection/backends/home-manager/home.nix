{ pkgs, input }:
let
  resolvePackages = import ./packages/default.nix { inherit pkgs; };
in {
  home.username = input.identity.name;
  home.homeDirectory = input.identity.homeDirectory;
  home.stateVersion = input.state.home.stateVersion;
  home.packages = resolvePackages input.packages.home;

  programs.home-manager.enable = true;
}
