{ input }:
let
  registry = {
    android-tools = import ./android-tools.nix;
    clash-verge-rev = import ./clash-verge-rev.nix;
    embedded-dev = import ./embedded-dev.nix;
    zsh = import ./zsh.nix;
  };
  packageIds =
    builtins.sort builtins.lessThan (builtins.attrNames input.packages.home);
in builtins.concatLists (map (packageId:
  if builtins.hasAttr packageId registry then
    [ (registry.${packageId} { inherit input; }) ]
  else
    [ ]) packageIds)
