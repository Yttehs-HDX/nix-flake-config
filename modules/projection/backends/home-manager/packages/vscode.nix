{ ... }:
{ pkgs, inputs, ... }:
let packageSources = import ./package-sources.nix { inherit pkgs inputs; };
in {
  programs.vscode = {
    enable = true;
    package = packageSources.homeCustomSources.vscode;
  };
}
