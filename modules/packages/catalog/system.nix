# System-scope package metadata registry.
#
# Every system-scope package must have an explicit entry here.
# Entries are grouped by classification and sorted alphabetically within
# each group.
let
  presets = import ../presets.nix;
  inherit (presets)
    linuxSystemHost crossPlatformSystemHost linuxDesktopSystemHost;
in {
  # ── Linux system packages ─────────────────────────────────────────────
  asusctl = linuxSystemHost "service";
  bluetooth = linuxSystemHost "service";
  firewall = linuxSystemHost "service";
  nix-ld = linuxSystemHost "package";
  nvidia = linuxSystemHost "service";
  refind = linuxSystemHost "package";
  rog-control-center = linuxSystemHost "service";
  supergfxctl = linuxSystemHost "service";
  tlp = linuxSystemHost "service";
  udisks2 = linuxSystemHost "service";
  virt-manager = linuxSystemHost "package";
  waydroid = linuxSystemHost "service";
  zram = linuxSystemHost "service";

  # ── Cross-platform system packages ────────────────────────────────────
  docker = crossPlatformSystemHost "package";
  hello = crossPlatformSystemHost "package";
  networking = crossPlatformSystemHost "service";
  wireshark = crossPlatformSystemHost "package";

  # ── Linux desktop system packages ─────────────────────────────────────
  sddm = linuxDesktopSystemHost "desktop-component";
}
