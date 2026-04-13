{ lib, current }:
let
  packageCatalog = import ../package-governance { inherit lib; };
  enabled = scope: declaredBy: definitions:
    lib.filterAttrs (packageId: definition:
      definition.enable
      && packageCatalog.isReachableFromSource scope declaredBy packageId
      && packageCatalog.supportedFor scope current packageId) definitions;
in {
  home = if current.scopes.home then
    enabled "home" "user" current.user.packages
    // enabled "home" "host" current.host.packages
  else
    { };
  system = if current.scopes.system then
    enabled "system" "host" current.host.packages
  else
    { };
}
