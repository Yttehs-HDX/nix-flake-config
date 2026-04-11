{ lib, input }:
let
  registry = { hyprland = import ./hyprland-session.nix; };
  resolve = packageId:
    if builtins.hasAttr packageId registry then
      [ (registry.${packageId} { inherit input; }) ]
    else
      [ ];
in lib.concatMap resolve
(lib.sort lib.lessThan (builtins.attrNames input.packages.home))
