{ lib, current }:
let
  packageCatalog = import ../internal/package-catalog.nix { inherit lib; };

  collect = scope: definitions:
    lib.filterAttrs (_: value: value != null) (lib.mapAttrs
      (packageId: definition:
        if definition.enable then
          packageCatalog.unsupportedInfoFor scope current packageId
        else
          null) definitions);
in {
  home =
    if current.scopes.home then collect "home" current.user.packages else { };
  system = if current.scopes.system then
    collect "system" current.host.packages
  else
    { };
}
