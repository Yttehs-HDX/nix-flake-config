{ lib }:
let
  normalizeEntry = softwareId: definition:
    let
      attrs = if builtins.isAttrs definition then
        definition
      else {
        enable = definition;
      };
      explicitSettings = attrs.settings or { };
      implicitSettings = builtins.removeAttrs attrs [ "enable" "settings" ];
    in {
      inherit softwareId;
      enable = attrs.enable or true;
      settings = lib.recursiveUpdate implicitSettings explicitSettings;
    };

  fromPackageNames = packageNames:
    lib.genAttrs packageNames (_: { enable = true; });

  mergeDefinitions = definitions:
    lib.foldl' lib.recursiveUpdate { } definitions;
in {
  user = user:
    lib.mapAttrs normalizeEntry (mergeDefinitions [
      (fromPackageNames user.packages.common)
      user.programs
      user.services
      user.software
    ]);

  host = host:
    lib.mapAttrs normalizeEntry (mergeDefinitions [
      (fromPackageNames host.packages.system)
      host.software
    ]);
}
