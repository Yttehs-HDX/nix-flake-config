{ input }:
{ lib, ... }:
let
  packageModules = import ../../common/package-modules.nix {
    inherit lib input;
    backendType = "home-manager";
    scope = "home";
  };
  integrationModules = import ./integrations/default.nix { inherit lib input; };
  unsupportedWarnings = import ../../common/unsupported-warnings.nix {
    inherit lib input;
    scope = "home";
  };
in {
  warnings = unsupportedWarnings;
  imports = packageModules ++ integrationModules;

  home.username = input.identity.name;
  home.homeDirectory = input.identity.homeDirectory;
  home.stateVersion = input.state.home.stateVersion;

  programs.home-manager.enable = true;
}
