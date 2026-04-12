# System-scope package metadata registry.
#
# This registry now merges two sources:
# 1. Package definitions from modules/package-definitions (preferred)
# 2. Legacy inline entries (to be migrated)
#
# Packages with definitions take precedence. Legacy entries remain for
# packages not yet migrated to the definition system.
let
  presets = import ../presets.nix;
  taxonomy = import ../taxonomy.nix;
  inherit (presets)
    linuxSystemHost crossPlatformSystemHost linuxDesktopSystemHost;
  inherit (taxonomy) targets;

  # Load package definitions
  lib = builtins; # Minimal lib for filtering
  packageDefinitions = import ../../package-definitions { inherit lib; };

  # Extract metadata from definitions for system-scope packages
  # Filter to only packages that have system targets in their allowedTargets
  systemDefinitionMetadata = builtins.mapAttrs (id: def: def.metadata)
    (builtins.listToAttrs (builtins.filter (item: item != null) (map (id:
      let
        def = packageDefinitions.${id};
        hasSystemTarget = builtins.any (target:
          target == taxonomy.targets.nixosSystem || target
          == taxonomy.targets.darwinSystem) def.metadata.allowedTargets;
      in if hasSystemTarget then {
        name = id;
        value = def;
      } else
        null) (builtins.attrNames packageDefinitions))));

  # Legacy inline entries (to be migrated to package definitions)
  legacyEntries = {
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
    networking = crossPlatformSystemHost "service";
    wireshark = crossPlatformSystemHost "package";

    # ── Linux desktop system packages ─────────────────────────────────────
    sddm = linuxDesktopSystemHost "desktop-component";
  };
  # Merge definitions (preferred) with legacy entries (fallback)
  # Definitions override legacy entries for the same package ID
in legacyEntries // systemDefinitionMetadata
