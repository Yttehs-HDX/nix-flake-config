# Home-scope package metadata registry.
#
# This registry is derived only from package definitions in
# modules/packages.
{ lib }:
let
  taxonomy = import ../taxonomy.nix;
  fromDefinitions = import ./from-definitions.nix { inherit lib taxonomy; };
in fromDefinitions "home"
