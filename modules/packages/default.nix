# Package metadata system entry point.
#
# Re-exports the public API from rules and diagnostics.
# Consumers import this file as:
#   packageCatalog = import ../packages { inherit lib; };
{ lib }:
let
  rules = import ./rules.nix { inherit lib; };
  diagnostics = import ./diagnostics.nix { inherit lib; };
in rules // diagnostics
