# Package Definitions Loader
#
# Automatically discovers and loads all package definitions from subdirectories.
# Each package definition must be in modules/packages/<packageId>/default.nix
#
# To add a new package:
# 1. Create modules/packages/<packageId>/default.nix
# 2. Export { packageId, metadata, defaultSettings, backends }
# 3. No changes needed to this file - auto-discovery handles it
{ lib }:
let
  # Get the path to this directory
  defPath = ./.;

  # Read all entries in the packages directory
  allEntries = builtins.readDir defPath;

  # Filter to only directories (excluding this default.nix file's directory entry)
  packageDirs = builtins.filter (name: allEntries.${name} == "directory")
    (builtins.attrNames allEntries);

  # Import each package definition
  # Each must have a default.nix that exports the definition structure
  allDefinitions =
    map (dirName: import (defPath + "/${dirName}") { inherit lib; })
    packageDirs;

  # Convert list to attrset keyed by packageId
  definitionsById = builtins.listToAttrs (map (def: {
    name = def.packageId;
    value = def;
  }) allDefinitions);
in definitionsById
