# Package metadata presets.
#
# Each preset produces a complete metadata record for a specific
# combination of ownership, platform constraints, and missing strategy.
# Catalog entries should pick the preset that matches their classification
# rather than applying a generic template and overriding fields with //.
let
  taxonomy = import ./taxonomy.nix;
  inherit (taxonomy) hostKinds allHostKinds missingStrategies owners;
in {
  # Cross-platform user package, available on all home targets.
  # Examples: bat, jq, ripgrep, git
  crossPlatformUserPackage = kind: {
    inherit kind;
    owner = owners.user;
    allowedHostKinds = allHostKinds;
    allowedTargets = taxonomy.allHomeTargets;
    requiresDesktop = false;
    missingStrategy = missingStrategies.notApplicable;
  };

  # Linux desktop user package — requires Linux host with desktop enabled.
  # Works on NixOS and standalone home-manager (both can be Linux).
  # Examples: hyprland, rofi, waybar
  linuxDesktopUser = kind: {
    inherit kind;
    owner = owners.user;
    allowedHostKinds = [ hostKinds.nixos hostKinds.standaloneHomeManager ];
    allowedTargets =
      [ taxonomy.targets.nixosHome taxonomy.targets.standaloneHomeManagerHome ];
    requiresDesktop = true;
    missingStrategy = missingStrategies.skip;
  };

  # Linux desktop host-controlled package.
  # Same platform constraints as linuxDesktopUser but owned by the host.
  # Examples: blueman
  linuxDesktopHost = kind: {
    inherit kind;
    owner = owners.host;
    allowedHostKinds = [ hostKinds.nixos hostKinds.standaloneHomeManager ];
    allowedTargets =
      [ taxonomy.targets.nixosHome taxonomy.targets.standaloneHomeManagerHome ];
    requiresDesktop = true;
    missingStrategy = missingStrategies.skip;
  };

  # Package auto-installed on Linux only; on Darwin kept as a
  # declaration with a manual-install hint.
  # Works on NixOS and standalone home-manager (both can be Linux).
  # Examples: google-chrome, jetbrains-toolbox, krita
  darwinHintManual = kind: {
    inherit kind;
    owner = owners.user;
    allowedHostKinds = [ hostKinds.nixos hostKinds.standaloneHomeManager ];
    allowedTargets =
      [ taxonomy.targets.nixosHome taxonomy.targets.standaloneHomeManagerHome ];
    requiresDesktop = false;
    missingStrategy = missingStrategies.hintManual;
    unsupportedReason =
      "This package is kept as a declaration, but the Darwin backend does not auto-install it.";
    unsupportedSuggestion =
      "Install it manually on macOS, for example with the App Store, Homebrew, or the vendor installer.";
  };

  # Linux-only system package, host-owned.
  # Examples: nvidia, bluetooth, tlp
  linuxSystemHost = kind: {
    inherit kind;
    owner = owners.host;
    allowedHostKinds = [ hostKinds.nixos ];
    allowedTargets = [ taxonomy.targets.nixosSystem ];
    requiresDesktop = false;
    missingStrategy = missingStrategies.skip;
  };

  # Cross-platform system package, host-owned.
  # Examples: docker, networking, wireshark
  crossPlatformSystemHost = kind: {
    inherit kind;
    owner = owners.host;
    allowedHostKinds = allHostKinds;
    allowedTargets = taxonomy.allSystemTargets;
    requiresDesktop = false;
    missingStrategy = missingStrategies.notApplicable;
  };

  # Linux desktop system package, requires NixOS with desktop enabled.
  # Examples: sddm
  linuxDesktopSystemHost = kind: {
    inherit kind;
    owner = owners.host;
    allowedHostKinds = [ hostKinds.nixos ];
    allowedTargets = [ taxonomy.targets.nixosSystem ];
    requiresDesktop = true;
    missingStrategy = missingStrategies.skip;
  };
}
