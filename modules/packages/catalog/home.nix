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
  lib = builtins;  # Minimal lib for filtering
  packageDefinitions = import ../../package-definitions { inherit lib; };

  # Extract metadata from definitions for home-scope packages
  # Filter to only packages that have home targets in their allowedTargets
  homeDefinitionMetadata = builtins.mapAttrs (id: def: def.metadata) (
    builtins.listToAttrs (
      builtins.filter (item: item != null) (
        map (id:
          let
            def = packageDefinitions.${id};
            hasHomeTarget = builtins.any (target:
              target == taxonomy.targets.nixosHome ||
              target == taxonomy.targets.darwinHome ||
              target == taxonomy.targets.standaloneHomeManagerHome
            ) def.metadata.allowedTargets;
          in
          if hasHomeTarget then { name = id; value = def; } else null
        ) (builtins.attrNames packageDefinitions)
      )
    )
  );

  # Legacy inline entries (to be migrated to package definitions)
  legacyEntries = {
    # ── Cross-platform user packages ──────────────────────────────────────
    android-tools = crossPlatformUserPackage "package";
    asciiquarium = crossPlatformUserPackage "package";
    bat = crossPlatformUserPackage "package";
    btop = crossPlatformUserPackage "package";
    cava = crossPlatformUserPackage "theme-consumer";
    cbonsai = crossPlatformUserPackage "package";
    cmatrix = crossPlatformUserPackage "package";
    codex = crossPlatformUserPackage "integration-heavy";
    cryptsetup = crossPlatformUserPackage "package";
    dig = crossPlatformUserPackage "package";
    direnv = crossPlatformUserPackage "package";
    duf = crossPlatformUserPackage "package";
    eza = crossPlatformUserPackage "package";
    fastfetch = crossPlatformUserPackage "package";
    figlet = crossPlatformUserPackage "package";
    file = crossPlatformUserPackage "package";
    fzf = crossPlatformUserPackage "package";
    gh = crossPlatformUserPackage "package";
    # git = crossPlatformUserPackage "package";  # Now in definitions
    github-copilot-cli = crossPlatformUserPackage "integration-heavy";
    # hello = crossPlatformUserPackage "package";  # Now in definitions
    hexecute = crossPlatformUserPackage "custom";
    htop = crossPlatformUserPackage "package";
    huggingface-hub = crossPlatformUserPackage "package";
    jq = crossPlatformUserPackage "package";
    kitty = crossPlatformUserPackage "package";
    lazydocker = crossPlatformUserPackage "package";
    lazygit = crossPlatformUserPackage "package";
    lolcat = crossPlatformUserPackage "package";
    mikusays = crossPlatformUserPackage "custom";
    nixvim = crossPlatformUserPackage "integration-heavy";
    net-tools = crossPlatformUserPackage "package";
    nerd-fonts-jetbrains-mono = crossPlatformUserPackage "theme-consumer";
    nix-index = crossPlatformUserPackage "environment";
    nixfmt-classic = crossPlatformUserPackage "package";
    nmap = crossPlatformUserPackage "package";
    noto-fonts = crossPlatformUserPackage "theme-consumer";
    noto-fonts-cjk-sans = crossPlatformUserPackage "theme-consumer";
    noto-fonts-cjk-serif = crossPlatformUserPackage "theme-consumer";
    noto-fonts-emoji-blob-bin = crossPlatformUserPackage "theme-consumer";
    pipes-rs = crossPlatformUserPackage "package";
    poppler-utils = crossPlatformUserPackage "package";
    ripgrep = crossPlatformUserPackage "package";
    scrcpy = crossPlatformUserPackage "package";
    tgpt = crossPlatformUserPackage "package";
    tesseract = crossPlatformUserPackage "package";
    tldr = crossPlatformUserPackage "package";
    tmux = crossPlatformUserPackage "package";
    translate-shell = crossPlatformUserPackage "package";
    unrar = crossPlatformUserPackage "package";
    unzip = crossPlatformUserPackage "package";
    vlc = crossPlatformUserPackage "gui";
    vscode = crossPlatformUserPackage "gui";
    wget = crossPlatformUserPackage "package";
    xdg = crossPlatformUserPackage "environment";
    yazi = crossPlatformUserPackage "package";
    zip = crossPlatformUserPackage "package";
    zsh = crossPlatformUserPackage "environment";

    # ── Linux desktop user packages ───────────────────────────────────────
    brightnessctl = linuxDesktopUser "desktop-component";
    cliphist = linuxDesktopUser "desktop-component";
    fcitx5 = linuxDesktopUser "desktop-input-method";
    grimblast = linuxDesktopUser "desktop-component";
    hypridle = linuxDesktopUser "service";
    # hyprland = linuxDesktopUser "desktop-session";  # Now in definitions
    hyprpicker = linuxDesktopUser "desktop-component";
    hyprpolkitagent = linuxDesktopUser "service";
    kdeconnect = linuxDesktopUser "service";
    libnotify = linuxDesktopUser "desktop-component";
    network-manager = linuxDesktopUser "service";
    ocr = linuxDesktopUser "custom";
    playerctl = linuxDesktopUser "desktop-component";
    pulseaudio = linuxDesktopUser "desktop-component";
    rofi = linuxDesktopUser "desktop-component";
    rofimoji = linuxDesktopUser "desktop-component";
    seahorse = linuxDesktopUser "gui";
    swappy = linuxDesktopUser "desktop-component";
    swaylock-effects = linuxDesktopUser "theme-consumer";
    swaync = linuxDesktopUser "desktop-component";
    swww = linuxDesktopUser "desktop-component";
    udisks2 = linuxDesktopUser "service";
    waybar = linuxDesktopUser "desktop-component";
    wl-clipboard = linuxDesktopUser "desktop-component";

    # ── Linux desktop host-controlled packages ────────────────────────────
    blueman = linuxDesktopHost "desktop-component";

    # ── Darwin manual-install hint packages ───────────────────────────────
    clash-verge-rev = darwinHintManual "integration-heavy";
    feishu = darwinHintManual "gui";
    google-chrome = darwinHintManual "gui";
    hmcl = darwinHintManual "gui";
    jetbrains-toolbox = darwinHintManual "gui";
    krita = darwinHintManual "gui";
    obs-studio = darwinHintManual "gui";
    onlyoffice = darwinHintManual "gui";
    osu-lazer-bin = darwinHintManual "gui";
    qq = darwinHintManual "gui";
    universal-android-debloater = darwinHintManual "gui";
    wechat = darwinHintManual "gui";

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
in
# Merge definitions (preferred) with legacy entries (fallback)
# Definitions override legacy entries for the same package ID
legacyEntries // homeDefinitionMetadata
