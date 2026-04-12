{ lib, current }:
let
  packageCatalog = import ../internal/package-catalog.nix { inherit lib; };

  collect = scope: declaredBy: definitions:
    lib.filterAttrs (_: value: value != null) (lib.mapAttrs
      (packageId: definition:
        if definition.enable
        && packageCatalog.visibleForSource scope declaredBy packageId then
          packageCatalog.unsupportedInfoFor scope current packageId
        else
          null) definitions);
in {
  home = if current.scopes.home then
    collect "home" "user" current.user.packages
    // collect "home" "host" current.host.packages
  else
    { };
  system = if current.scopes.system then
    collect "system" "host" current.host.packages
  else
    { };
}
