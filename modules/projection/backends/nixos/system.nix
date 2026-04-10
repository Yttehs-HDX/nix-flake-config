{ input }:
{ pkgs, ... }:
let resolvePackages = import ./packages/default.nix { inherit pkgs; };
in {
  networking.hostName = input.hostId;
  system.stateVersion = input.current.host.system.stateVersion;
  users.mutableUsers = true;
  environment.systemPackages = resolvePackages input.packages.system;
}
