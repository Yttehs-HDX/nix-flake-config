# Package Definitions Loader
#
# This module loads all package definitions from subdirectories and provides
# them as an attrset indexed by packageId.
#
# Each package definition must export:
# - packageId: string
# - metadata: attrset (kind, owner, allowedHostKinds, allowedTargets, etc.)
# - defaultSettings: attrset
# - backends: attrset { home-manager, nixos, nix-darwin }
{ lib }:
let
  # Import individual package definitions
  # Each package definition is in its own directory
  git = import ./git { inherit lib; };
  hello = import ./hello { inherit lib; };
  hyprland = import ./hyprland { inherit lib; };

  # Collect all definitions into an attrset indexed by packageId
  allDefinitions = [
    git
    hello
    hyprland
  ];

  # Convert list to attrset keyed by packageId
  definitionsById = builtins.listToAttrs (map (def: {
    name = def.packageId;
    value = def;
  }) allDefinitions);
in
definitionsById
