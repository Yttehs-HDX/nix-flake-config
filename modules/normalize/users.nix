{ lib, profile }:
let normalizeSoftware = import ./software.nix { inherit lib; };
in lib.mapAttrs (userId: user:
  user // {
    inherit userId;
    software = normalizeSoftware.user user;
  }) profile.users
