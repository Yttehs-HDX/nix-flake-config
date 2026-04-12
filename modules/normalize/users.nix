{ lib, profile }:
let normalizePackages = import ./packages.nix { inherit lib; };
in lib.mapAttrs (userId: user:
  user // {
    inherit userId;
    packages = normalizePackages.user user;
  }) profile.users
