{ lib }:
let
  desktopLinux = kind: {
    inherit kind;
    desktopScoped = true;
    linuxOnly = true;
    requiresDesktop = true;
  };

  darwinManualGui = kind: {
    inherit kind;
    linuxOnly = true;
    unsupportedReason =
      "This package is kept as a declaration, but the Darwin backend does not auto-install it.";
    unsupportedSuggestion =
      "Install it manually on macOS, for example with the App Store, Homebrew, or the vendor installer.";
  };

  linuxSystem = kind: {
    inherit kind;
    linuxOnly = true;
  };

  catalog = {
    home = {
      android-tools = { kind = "package"; };
      asciiquarium = { kind = "package"; };
      bat = { kind = "package"; };
      btop = { kind = "package"; };
      blueman = desktopLinux "desktop-component";
      brightnessctl = desktopLinux "desktop-component";
      cava = { kind = "theme-consumer"; };
      cbonsai = { kind = "package"; };
      clash-verge-rev = darwinManualGui "integration-heavy";
      cliphist = desktopLinux "desktop-component";
      cmatrix = { kind = "package"; };
      codex = { kind = "integration-heavy"; };
      command-not-found = { kind = "environment"; };
      github-copilot-cli = { kind = "integration-heavy"; };
      cryptsetup = { kind = "package"; };
      dig = { kind = "package"; };
      direnv = { kind = "package"; };
      duf = { kind = "package"; };
      embedded-dev = { kind = "integration-heavy"; };
      eza = { kind = "package"; };
      feishu = darwinManualGui "gui";
      fastfetch = { kind = "package"; };
      fcitx5 = desktopLinux "desktop-input-method";
      figlet = { kind = "package"; };
      file = { kind = "package"; };
      fzf = { kind = "package"; };
      gh = { kind = "package"; };
      git = { kind = "package"; };
      gnome-keyring = desktopLinux "service";
      google-chrome = darwinManualGui "gui";
      grimblast = desktopLinux "desktop-component";
      hexecute = { kind = "custom"; };
      hello = { kind = "package"; };
      hmcl = darwinManualGui "gui";
      htop = { kind = "package"; };
      huggingface-hub = { kind = "package"; };
      hypridle = desktopLinux "service";
      hyprpicker = desktopLinux "desktop-component";
      hyprland = desktopLinux "desktop-session";
      hyprpolkitagent = desktopLinux "service";
      jq = { kind = "package"; };
      jetbrains-toolbox = darwinManualGui "gui";
      kdeconnect = desktopLinux "service";
      kitty = { kind = "package"; };
      krita = darwinManualGui "gui";
      lazydocker = { kind = "package"; };
      lazygit = { kind = "package"; };
      libnotify = desktopLinux "desktop-component";
      lolcat = { kind = "package"; };
      mikusays = { kind = "custom"; };
      neovim = { kind = "integration-heavy"; };
      net-tools = { kind = "package"; };
      network-manager = desktopLinux "service";
      nerd-fonts-jetbrains-mono = { kind = "theme-consumer"; };
      nix-index = { kind = "environment"; };
      nixfmt-classic = { kind = "package"; };
      nmap = { kind = "package"; };
      noto-fonts = { kind = "theme-consumer"; };
      noto-fonts-cjk-sans = { kind = "theme-consumer"; };
      noto-fonts-cjk-serif = { kind = "theme-consumer"; };
      noto-fonts-emoji-blob-bin = { kind = "theme-consumer"; };
      obs-studio = darwinManualGui "gui";
      ocr = desktopLinux "custom";
      onlyoffice = darwinManualGui "gui";
      osu-lazer-bin = darwinManualGui "gui";
      pipewire = desktopLinux "service";
      pipes-rs = { kind = "package"; };
      playerctl = desktopLinux "desktop-component";
      poppler-utils = { kind = "package"; };
      pulseaudio = desktopLinux "desktop-component";
      qq = darwinManualGui "gui";
      ripgrep = { kind = "package"; };
      rofi = desktopLinux "desktop-component";
      rofimoji = desktopLinux "desktop-component";
      scrcpy = { kind = "package"; };
      seahorse = desktopLinux "gui";
      swaylock-effects = desktopLinux "theme-consumer";
      swaync = desktopLinux "desktop-component";
      swww = desktopLinux "desktop-component";
      swappy = desktopLinux "desktop-component";
      tgpt = { kind = "package"; };
      tesseract = { kind = "package"; };
      tldr = { kind = "package"; };
      tmux = { kind = "package"; };
      translate-shell = { kind = "package"; };
      udisks2 = desktopLinux "service";
      universal-android-debloater = darwinManualGui "gui";
      unrar = { kind = "package"; };
      unzip = { kind = "package"; };
      vlc = { kind = "gui"; };
      vscode = { kind = "gui"; };
      waybar = desktopLinux "desktop-component";
      wechat = darwinManualGui "gui";
      wget = { kind = "package"; };
      wl-clipboard = desktopLinux "desktop-component";
      xdg = { kind = "environment"; };
      yazi = { kind = "package"; };
      zip = { kind = "package"; };
      zsh = { kind = "environment"; };
    };

    system = {
      asusctl = linuxSystem "service";
      bluetooth = linuxSystem "service";
      docker = { kind = "package"; };
      firewall = linuxSystem "service";
      grub = linuxSystem "service";
      hello = { kind = "package"; };
      locale = { kind = "service"; };
      networking = { kind = "service"; };
      nix-ld = { kind = "package"; };
      nvidia = linuxSystem "service";
      pipewire = linuxSystem "service";
      refind = linuxSystem "package";
      rog-control-center = linuxSystem "service";
      sddm = desktopLinux "desktop-component";
      supergfxctl = linuxSystem "service";
      tlp = linuxSystem "service";
      udisks2 = linuxSystem "service";
      virt-manager = { kind = "package"; };
      waydroid = linuxSystem "service";
      wireshark = { kind = "package"; };
      zram = linuxSystem "service";
    };
  };

  hostPlatform = current:
    if current ? host then
      current.host.platform.system
    else if current ? current then
      current.current.host.platform.system
    else
      null;

  desktopEnabled = current:
    if current ? effectiveCapabilities then
      current.effectiveCapabilities.desktop.enable
    else if current ? current then
      current.current.effectiveCapabilities.desktop.enable
    else
      false;

  metadataFor = scope: packageId:
    catalog.${scope}.${packageId} or {
      kind = "package";
    };

  platformInfo = current:
    let
      platformSystem = hostPlatform current;
      isLinuxPlatform = platformSystem != null
        && lib.hasSuffix "-linux" platformSystem;
      isDarwinPlatform = platformSystem != null
        && lib.hasSuffix "-darwin" platformSystem;
    in {
      inherit platformSystem isLinuxPlatform isDarwinPlatform;
      platform = if isDarwinPlatform then
        "darwin"
      else if isLinuxPlatform then
        "linux"
      else if platformSystem == null then
        "unknown"
      else
        platformSystem;
    };

  supportedFor = scope: current: packageId:
    let
      metadata = metadataFor scope packageId;
      platform = platformInfo current;
    in (!(metadata.linuxOnly or false) || platform.isLinuxPlatform)
    && (!(metadata.requiresDesktop or false) || desktopEnabled current);

  unsupportedInfoFor = scope: current: packageId:
    let
      metadata = metadataFor scope packageId;
      platform = platformInfo current;
      unsupportedPlatform = (metadata.linuxOnly or false)
        && !platform.isLinuxPlatform;
    in if !unsupportedPlatform then
      null
    else {
      name = packageId;
      inherit scope;
      backend = if current ? backend then
        current.backend.type
      else
        current.current.backend.type;
      platform = platform.platform;
      reason =
        metadata.unsupportedReason or "This package is only implemented on Linux backends.";
      suggestion =
        metadata.unsupportedSuggestion or "Use a Linux backend for automatic installation, or install it manually on this platform.";
    };
in { inherit catalog metadataFor supportedFor unsupportedInfoFor; }
