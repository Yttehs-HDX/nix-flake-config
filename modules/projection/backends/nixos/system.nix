{ input }:
{ pkgs, lib ? pkgs.lib, config ? { users.mutableUsers = true; }, ... }:
let
  resolvePackages = import ./packages/default.nix { inherit pkgs; };
  hasInitialHashedPassword = input.account.initialHashedPassword != null;
in {
  networking.hostName = input.hostId;
  system.stateVersion = input.current.host.system.stateVersion;
  environment.systemPackages = resolvePackages input.packages.system;
} // lib.optionalAttrs hasInitialHashedPassword {
  users.mutableUsers = lib.mkDefault true;

  assertions = [{
    assertion = config.users.mutableUsers;
    message = ''
      `profile.users.${input.userId}.initialHashedPassword` on host `${input.hostId}`
      requires `users.mutableUsers = true` to preserve first-creation-only semantics.
    '';
  }];
}
