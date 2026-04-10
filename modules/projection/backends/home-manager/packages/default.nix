{ pkgs }:
let
  registry = {
    hello = import ./hello.nix { inherit pkgs; };
  };
in
packageNames:
  map
    (name:
      if builtins.hasAttr name registry then
        registry.${name}
      else
        throw "Unknown Home Manager package `${name}`.")
    packageNames
