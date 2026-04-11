{ ... }:
{ pkgs, inputs, ... }:
let packageSources = import ./package-sources.nix { inherit pkgs inputs; };
in { home.packages = [ packageSources.homeCustomSources.hexecute ]; }
