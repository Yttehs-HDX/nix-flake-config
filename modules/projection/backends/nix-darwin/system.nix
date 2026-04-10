{ input }:
{ lib, ... }:
let packageModules = import ./packages/default.nix { inherit lib input; };
in {
  imports = packageModules;

  networking.hostName = input.hostId;
  nixpkgs.hostPlatform = input.current.host.platform.system;
  system.stateVersion = input.current.host.system.stateVersion;
}
