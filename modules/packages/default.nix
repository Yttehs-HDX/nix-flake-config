# Package Definitions Loader
#
# Automatically discovers and loads all package definitions from subdirectories.
# Each package definition must be in modules/packages/<packageId>/default.nix
#
# To add a new package:
# 1. Create modules/packages/<packageId>/default.nix
# 2. Export { packageId, metadata, backends } (additional fields may be included if needed)
# 3. No changes needed to this file - auto-discovery handles it
{ lib }:
let
  # Get the path to this directory
  defPath = ./.;

  # Read all entries in the packages directory
  allEntries = builtins.readDir defPath;

  # Filter to only directories that contain a default.nix
  packageDirs = builtins.filter (name:
    allEntries.${name} == "directory"
    && builtins.pathExists (defPath + "/${name}/default.nix"))
    (builtins.attrNames allEntries);

  # Import each package definition
  # Each must have a default.nix that exports the definition structure
  allDefinitions =
    map (dirName: import (defPath + "/${dirName}") { inherit lib; })
    packageDirs;

  # Convert list to attrset keyed by packageId.
  # Validate uniqueness first: builtins.listToAttrs silently overwrites on duplicate names.
  _validatedDefinitions = builtins.foldl' (seen: def:
    if seen ? "${def.packageId}" then
      throw "Duplicate packageId '${def.packageId}' found in modules/packages"
    else
      seen // { "${def.packageId}" = true; }) { } allDefinitions;

  definitionsById = builtins.seq _validatedDefinitions (builtins.listToAttrs
    (map (def: {
      name = def.packageId;
      value = def;
    }) allDefinitions));
in definitionsById
