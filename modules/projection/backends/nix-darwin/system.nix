{ input }:
{ lib, ... }:
let
  packageModules = import ../../common/package-modules.nix {
    inherit lib input;
    backendType = "nix-darwin";
    scope = "system";
  };
  unsupportedWarnings = import ../../common/unsupported-warnings.nix {
    inherit lib input;
    scope = "system";
  };
in {
  warnings = unsupportedWarnings;
  imports = packageModules;

  networking.hostName = input.hostId;
  nixpkgs.hostPlatform = input.current.host.platform.system;
  system.stateVersion = input.current.host.system.stateVersion;
}
