{ lib, profile }:
lib.mapAttrs (userId: user: user // { inherit userId; }) profile.users
