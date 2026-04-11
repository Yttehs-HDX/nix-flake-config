{ input }:
{ lib, config ? { users.mutableUsers = true; }, ... }:
let
  packageModules = import ./packages/default.nix { inherit lib input; };
  integrationModules =
    import ./integrations/home-packages.nix { inherit lib input; };
  hasInitialHashedPassword = input.account.initialHashedPassword != null;
in {
  imports = packageModules ++ integrationModules;

  networking.hostName = input.hostId;
  system.stateVersion = input.current.host.system.stateVersion;
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
