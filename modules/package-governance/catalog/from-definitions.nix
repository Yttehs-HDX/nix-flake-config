{ lib, taxonomy }:
scope:
let
  packageDefinitions = import ../../packages { inherit lib; };

  allowedTargets = if scope == "home" then [
    taxonomy.targets.nixosHome
    taxonomy.targets.darwinHome
    taxonomy.targets.standaloneHomeManagerHome
  ] else if scope == "system" then [
    taxonomy.targets.nixosSystem
    taxonomy.targets.darwinSystem
  ] else
    throw "Unsupported catalog scope `${scope}`.";

  hasAllowedTarget = def:
    builtins.any (target: builtins.elem target allowedTargets)
    (def.metadata.allowedTargets or [ ]);

  scopedDefinitions = builtins.listToAttrs (builtins.filter (item: item != null)
    (map (packageId:
      let def = packageDefinitions.${packageId};
      in if hasAllowedTarget def then {
        name = packageId;
        value = def;
      } else
        null) (builtins.attrNames packageDefinitions)));
in builtins.mapAttrs (_: def: def.metadata) scopedDefinitions
