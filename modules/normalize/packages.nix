{ lib }:
let
  normalizeEntry = packageId: definition:
    let
      attrs = if builtins.isAttrs definition then
        definition
      else {
        enable = definition;
      };
      explicitSettings = attrs.settings or { };
      implicitSettings = builtins.removeAttrs attrs [ "enable" "settings" ];
    in {
      inherit packageId;
      enable = attrs.enable or true;
      settings = lib.recursiveUpdate implicitSettings explicitSettings;
    };

  mergeDefinitions = definitions:
    lib.foldl' lib.recursiveUpdate { } definitions;
in {
  user = user: lib.mapAttrs normalizeEntry user.packages;

  host = host: lib.mapAttrs normalizeEntry host.packages;
}
