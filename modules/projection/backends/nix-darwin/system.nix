{ input }:
{ pkgs, ... }:
let resolvePackages = import ./packages/default.nix { inherit pkgs; };
in {
  networking.hostName = input.hostId;
  nixpkgs.hostPlatform = input.current.host.platform.system;
  system.stateVersion = input.current.host.system.stateVersion;
  environment.systemPackages = resolvePackages input.packages.system;
}
