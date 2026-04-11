{ definition, ... }:
{ pkgs, ... }:
let
  packageName = definition.settings.package or "qt";
  package = if packageName == "cli" then pkgs.wireshark else pkgs.wireshark-qt;
in {
  programs.wireshark = {
    enable = true;
    inherit package;
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
