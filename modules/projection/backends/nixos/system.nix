{ pkgs, input }:
let
  resolvePackages = import ./packages/default.nix { inherit pkgs; };
in {
  networking.hostName = input.hostId;
  system.stateVersion = input.current.host.system.stateVersion;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  environment.systemPackages = resolvePackages input.packages.system;
}
