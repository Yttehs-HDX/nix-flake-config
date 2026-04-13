{ input }:
let
  packageDefinitions = import ../../packages { lib = builtins; };
  packageSet = input.packages.home or { };

  resolve = packageId: definition:
    if builtins.hasAttr packageId packageDefinitions then
      let
        backendPath =
          packageDefinitions.${packageId}.backends.nixos.system or null;
      in if backendPath == null then
        [ ]
      else
        [ ((import backendPath) { inherit input definition; }) ]
    else
      [ ];
in builtins.concatLists
(map (packageId: resolve packageId packageSet.${packageId})
  (builtins.sort builtins.lessThan (builtins.attrNames packageSet)))
