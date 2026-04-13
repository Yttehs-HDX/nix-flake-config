{ input, ... }:
{ ... }: {
  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  users.users.${input.identity.name}.extraGroups = [ "libvirtd" ];
}
