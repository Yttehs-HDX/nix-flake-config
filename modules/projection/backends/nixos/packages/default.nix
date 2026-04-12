{ lib, input }:
let
  registry = {
    asusctl = import ./asusctl.nix;
    bluetooth = import ./bluetooth.nix;
    docker = import ./docker.nix;
    firewall = import ./firewall.nix;
    networking = import ./networking.nix;
    nix-ld = import ./nix-ld.nix;
    nvidia = import ./nvidia.nix;
    refind = import ./refind.nix;
    rog-control-center = import ./rog-control-center.nix;
    sddm = import ./sddm.nix;
    supergfxctl = import ./supergfxctl.nix;
    tlp = import ./tlp.nix;
    udisks2 = import ./udisks2.nix;
    virt-manager = import ./virt-manager.nix;
    waydroid = import ./waydroid.nix;
    wireshark = import ./wireshark.nix;
    zram = import ./zram.nix;
  };

  resolve = packageId: definition:
    if builtins.hasAttr packageId registry then
      registry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported NixOS package `${packageId}` on host `${input.hostId}`.";
in map (packageId: resolve packageId input.packages.system.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.system))
