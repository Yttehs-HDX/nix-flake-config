{ pkgs, ... }:

{
  programs.virt-manager.enable = true;
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
