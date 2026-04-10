{ input }:
{ lib, ... }:
let softwareModules = import ./software/default.nix { inherit lib input; };
in {
  imports = softwareModules;

  networking.hostName = input.hostId;
  nixpkgs.hostPlatform = input.current.host.platform.system;
  system.stateVersion = input.current.host.system.stateVersion;
}
