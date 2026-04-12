# Home-scope package metadata registry.
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
    crossPlatformUserPackage linuxDesktopUser linuxDesktopHost darwinHintManual;
  inherit (taxonomy) targets missingStrategies owners;

  # Load package definitions
  lib = builtins; # Minimal lib for filtering
  packageDefinitions = import ../../package-definitions { inherit lib; };

  # Extract metadata from definitions for home-scope packages
  # Filter to only packages that have home targets in their allowedTargets
  homeDefinitionMetadata = builtins.mapAttrs (id: def: def.metadata)
    (builtins.listToAttrs (builtins.filter (item: item != null) (map (id:
      let
        def = packageDefinitions.${id};
        hasHomeTarget = builtins.any (target:
          target == taxonomy.targets.nixosHome || target
          == taxonomy.targets.darwinHome || target
          == taxonomy.targets.standaloneHomeManagerHome)
          def.metadata.allowedTargets;
      in if hasHomeTarget then {
        name = id;
        value = def;
      } else
        null) (builtins.attrNames packageDefinitions))));

  # Legacy inline entries (to be migrated to package definitions)
  legacyEntries = {
    # ── Cross-platform user packages ──────────────────────────────────────
    # android-tools = crossPlatformUserPackage "package";  # Now in definitions
    # asciiquarium = crossPlatformUserPackage "package";  # Now in definitions
    # bat = crossPlatformUserPackage "package";  # Now in definitions
    # btop = crossPlatformUserPackage "package";  # Now in definitions
    # cava = crossPlatformUserPackage "theme-consumer";  # Now in definitions
    # cbonsai = crossPlatformUserPackage "package";  # Now in definitions
    # cmatrix = crossPlatformUserPackage "package";  # Now in definitions
    # codex = crossPlatformUserPackage "integration-heavy";  # Now in definitions
    # cryptsetup = crossPlatformUserPackage "package";  # Now in definitions
    # dig = crossPlatformUserPackage "package";  # Now in definitions
    # direnv = crossPlatformUserPackage "package";  # Now in definitions
    # duf = crossPlatformUserPackage "package";  # Now in definitions
    # eza = crossPlatformUserPackage "package";  # Now in definitions
    # fastfetch = crossPlatformUserPackage "package";  # Now in definitions
    # figlet = crossPlatformUserPackage "package";  # Now in definitions
    # file = crossPlatformUserPackage "package";  # Now in definitions
    # fzf = crossPlatformUserPackage "package";  # Now in definitions
    # gh = crossPlatformUserPackage "package";  # Now in definitions
    # git = crossPlatformUserPackage "package";  # Now in definitions
    # github-copilot-cli = crossPlatformUserPackage "integration-heavy";  # Now in definitions
    hello = crossPlatformUserPackage "package";
    # hexecute = crossPlatformUserPackage "custom";  # Now in definitions
    # htop = crossPlatformUserPackage "package";  # Now in definitions
    # huggingface-hub = crossPlatformUserPackage "package";  # Now in definitions
    # jq = crossPlatformUserPackage "package";  # Now in definitions
    # kitty = crossPlatformUserPackage "package";  # Now in definitions
    # lazydocker = crossPlatformUserPackage "package";  # Now in definitions
    # lazygit = crossPlatformUserPackage "package";  # Now in definitions
    # lolcat = crossPlatformUserPackage "package";  # Now in definitions
    # mikusays = crossPlatformUserPackage "custom";  # Now in definitions
    # nixvim = crossPlatformUserPackage "integration-heavy";  # Now in definitions
    # net-tools = crossPlatformUserPackage "package";  # Now in definitions
    # nerd-fonts-jetbrains-mono = crossPlatformUserPackage "theme-consumer";  # Now in definitions
    # nix-index = crossPlatformUserPackage "environment";  # Now in definitions
    # nixfmt-classic = crossPlatformUserPackage "package";  # Now in definitions
    # nmap = crossPlatformUserPackage "package";  # Now in definitions
    # noto-fonts = crossPlatformUserPackage "theme-consumer";  # Now in definitions
    # noto-fonts-cjk-sans = crossPlatformUserPackage "theme-consumer";  # Now in definitions
    # noto-fonts-cjk-serif = crossPlatformUserPackage "theme-consumer";  # Now in definitions
    # noto-fonts-emoji-blob-bin = crossPlatformUserPackage "theme-consumer";  # Now in definitions
    # pipes-rs = crossPlatformUserPackage "package";  # Now in definitions
    # poppler-utils = crossPlatformUserPackage "package";  # Now in definitions
    # ripgrep = crossPlatformUserPackage "package";  # Now in definitions
    # scrcpy = crossPlatformUserPackage "package";  # Now in definitions
    # tgpt = crossPlatformUserPackage "package";  # Now in definitions
    # tesseract = crossPlatformUserPackage "package";  # Now in definitions
    # tldr = crossPlatformUserPackage "package";  # Now in definitions
    # tmux = crossPlatformUserPackage "package";  # Now in definitions
    # translate-shell = crossPlatformUserPackage "package";  # Now in definitions
    # unrar = crossPlatformUserPackage "package";  # Now in definitions
    # unzip = crossPlatformUserPackage "package";  # Now in definitions
    # vlc = crossPlatformUserPackage "gui";  # Now in definitions
    # vscode = crossPlatformUserPackage "gui";  # Now in definitions
    # wget = crossPlatformUserPackage "package";  # Now in definitions
    # xdg = crossPlatformUserPackage "environment";  # Now in definitions
    # yazi = crossPlatformUserPackage "package";  # Now in definitions
    # zip = crossPlatformUserPackage "package";  # Now in definitions
    # zsh = crossPlatformUserPackage "environment";  # Now in definitions

    # ── Linux desktop user packages ───────────────────────────────────────
    # brightnessctl = linuxDesktopUser "desktop-component";  # Now in definitions
    # cliphist = linuxDesktopUser "desktop-component";  # Now in definitions
    # fcitx5 = linuxDesktopUser "desktop-input-method";  # Now in definitions
    # grimblast = linuxDesktopUser "desktop-component";  # Now in definitions
    # hypridle = linuxDesktopUser "service";  # Now in definitions
    # hyprland = linuxDesktopUser "desktop-session";  # Now in definitions
    # hyprpicker = linuxDesktopUser "desktop-component";  # Now in definitions
    # hyprpolkitagent = linuxDesktopUser "service";  # Now in definitions
    # kdeconnect = linuxDesktopUser "service";  # Now in definitions
    # libnotify = linuxDesktopUser "desktop-component";  # Now in definitions
    # network-manager = linuxDesktopUser "service";  # Now in definitions
    # ocr = linuxDesktopUser "custom";  # Now in definitions
    # playerctl = linuxDesktopUser "desktop-component";  # Now in definitions
    # pulseaudio = linuxDesktopUser "desktop-component";  # Now in definitions
    # rofi = linuxDesktopUser "desktop-component";  # Now in definitions
    # rofimoji = linuxDesktopUser "desktop-component";  # Now in definitions
    # seahorse = linuxDesktopUser "gui";  # Now in definitions
    # swappy = linuxDesktopUser "desktop-component";  # Now in definitions
    # swaylock-effects = linuxDesktopUser "theme-consumer";  # Now in definitions
    # swaync = linuxDesktopUser "desktop-component";  # Now in definitions
    # swww = linuxDesktopUser "desktop-component";  # Now in definitions
    # udisks2 = linuxDesktopUser "service";  # Now in definitions
    # waybar = linuxDesktopUser "desktop-component";  # Now in definitions
    # wl-clipboard = linuxDesktopUser "desktop-component";  # Now in definitions

    # ── Linux desktop host-controlled packages ────────────────────────────
    # blueman = linuxDesktopHost "desktop-component";  # Now in definitions

    # ── Darwin manual-install hint packages ───────────────────────────────
    # clash-verge-rev = darwinHintManual "integration-heavy";  # Now in definitions
    # feishu = darwinHintManual "gui";  # Now in definitions
    # google-chrome = darwinHintManual "gui";  # Now in definitions
    # hmcl = darwinHintManual "gui";  # Now in definitions
    # jetbrains-toolbox = darwinHintManual "gui";  # Now in definitions
    # krita = darwinHintManual "gui";  # Now in definitions
    # obs-studio = darwinHintManual "gui";  # Now in definitions
    # onlyoffice = darwinHintManual "gui";  # Now in definitions
    # osu-lazer-bin = darwinHintManual "gui";  # Now in definitions
    # qq = darwinHintManual "gui";  # Now in definitions
    # universal-android-debloater = darwinHintManual "gui";  # Now in definitions
    # wechat = darwinHintManual "gui";  # Now in definitions

    # ── Packages with custom constraints ──────────────────────────────────
    neovim = {
      kind = "integration-heavy";
      owner = owners.user;
      allowedHostKinds = [ "nixos" ];
      allowedTargets = [ targets.nixosHome ];
      requiresDesktop = false;
      missingStrategy = missingStrategies.hintManual;
      unsupportedReason =
        "Neovim default-editor integration is currently implemented only for NixOS backends.";
      unsupportedSuggestion =
        "Use a NixOS backend for automatic neovim default-editor setup, or use `packages.nixvim` for Home Manager-level editor configuration.";
    };

    embedded-dev = {
      kind = "integration-heavy";
      owner = owners.user;
      allowedHostKinds = [ "nixos" ];
      allowedTargets = [ targets.nixosHome ];
      requiresDesktop = false;
      missingStrategy = missingStrategies.hintManual;
      unsupportedReason =
        "This package currently relies on NixOS-side integration and is not implemented on this backend.";
      unsupportedSuggestion =
        "Use a NixOS backend for automatic setup, or configure the toolchain manually.";
    };

    gnome-keyring = {
      kind = "service";
      owner = owners.user;
      allowedHostKinds = [ "nixos" ];
      allowedTargets = [ targets.nixosHome ];
      requiresDesktop = true;
      missingStrategy = missingStrategies.hintManual;
      unsupportedReason =
        "gnome-keyring requires NixOS system-level integration for proper PAM and D-Bus setup.";
      unsupportedSuggestion =
        "Use a NixOS backend for automatic gnome-keyring setup, or configure the service manually.";
    };

    pipewire = {
      kind = "service";
      owner = owners.host;
      allowedHostKinds = [ "nixos" ];
      allowedTargets = [ targets.nixosHome ];
      requiresDesktop = false;
      missingStrategy = missingStrategies.hintManual;
      unsupportedReason =
        "This package currently relies on NixOS system integration and is not implemented on this backend.";
      unsupportedSuggestion =
        "Use a NixOS backend for automatic setup, or configure PipeWire manually on this host.";
    };
  };
  # Merge definitions (preferred) with legacy entries (fallback)
  # Definitions override legacy entries for the same package ID
in legacyEntries // homeDefinitionMetadata
