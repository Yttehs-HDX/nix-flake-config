{ input }:
let
  registry = { zsh = import ./zsh.nix; };
  packageIds =
    builtins.sort builtins.lessThan (builtins.attrNames input.packages.home);
in builtins.concatLists (map (packageId:
  if builtins.hasAttr packageId registry then
    [ (registry.${packageId} { inherit input; }) ]
  else
    [ ]) packageIds)
