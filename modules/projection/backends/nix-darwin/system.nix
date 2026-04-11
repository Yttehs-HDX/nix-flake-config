{ input }:
{ lib, ... }:
let
  packageModules = import ./packages/default.nix { inherit lib input; };
  unsupportedWarnings = map (info:
    "Package `${info.name}` is unsupported on `${info.backend}` (${info.platform}): ${info.reason} ${info.suggestion}")
    (lib.attrValues input.unsupportedPackages.system);
in {
  warnings = unsupportedWarnings;
  imports = packageModules;

  networking.hostName = input.hostId;
  nixpkgs.hostPlatform = input.current.host.platform.system;
  system.stateVersion = input.current.host.system.stateVersion;
}
