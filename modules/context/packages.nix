{ lib, current }:
let enabled = lib.filterAttrs (_: definition: definition.enable);
in {
  home = if current.scopes.home then enabled current.user.packages else { };
  system = if current.scopes.system then enabled current.host.packages else { };
}
