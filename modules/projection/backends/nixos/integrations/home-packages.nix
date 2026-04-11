{ lib, input }:
let
  registry = {
    blueman = import ./blueman.nix;
    gnome-keyring = import ./gnome-keyring.nix;
    hyprland = import ./hyprland-session.nix;
    niri = import ./niri-session.nix;
    pipewire = import ./pipewire.nix;
    udisks2 = import ./udisks2.nix;
  };
  resolve = packageId:
    if builtins.hasAttr packageId registry then
      [ (registry.${packageId} { inherit input; }) ]
    else
      [ ];
in lib.concatMap resolve
(lib.sort lib.lessThan (builtins.attrNames input.packages.home))
