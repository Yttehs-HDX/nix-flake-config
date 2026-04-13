{ ... }:
{ lib, ... }: {
  nix.settings.experimental-features = lib.mkAfter [ "nix-command" "flakes" ];
}
