{ input }:
{ lib, ... }:
let
  packageModules = import ./packages/default.nix { inherit lib input; };
  integrationModules = import ./integrations/default.nix { inherit lib input; };
  unsupportedWarnings = map (info:
    "Package `${info.name}` is unsupported on `${info.backend}` (${info.platform}): ${info.reason} ${info.suggestion}")
    (lib.attrValues input.unsupportedPackages.home);
in {
  warnings = unsupportedWarnings;
  imports = packageModules ++ integrationModules;

  home.username = input.identity.name;
  home.homeDirectory = input.identity.homeDirectory;
  home.stateVersion = input.state.home.stateVersion;

  programs.home-manager.enable = true;
}
