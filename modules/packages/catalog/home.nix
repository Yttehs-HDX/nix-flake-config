# Home-scope package metadata registry.
#
# Every home-scope package must have an explicit entry here.
# Entries are grouped by classification and sorted alphabetically within
# each group.
let
  presets = import ../presets.nix;
  taxonomy = import ../taxonomy.nix;
  inherit (presets)
    crossPlatformUserPackage linuxDesktopUser linuxDesktopHost darwinHintManual;
  inherit (taxonomy) targets missingStrategies owners;
in {
  # ── Cross-platform user packages ──────────────────────────────────────
  android-tools = crossPlatformUserPackage "package";
  asciiquarium = crossPlatformUserPackage "package";
  bat = crossPlatformUserPackage "package";
  btop = crossPlatformUserPackage "package";
  cava = crossPlatformUserPackage "theme-consumer";
  cbonsai = crossPlatformUserPackage "package";
  cmatrix = crossPlatformUserPackage "package";
  codex = crossPlatformUserPackage "integration-heavy";
  command-not-found = crossPlatformUserPackage "environment";
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
  git = crossPlatformUserPackage "package";
  github-copilot-cli = crossPlatformUserPackage "integration-heavy";
  hello = crossPlatformUserPackage "package";
  hexecute = crossPlatformUserPackage "custom";
  htop = crossPlatformUserPackage "package";
  huggingface-hub = crossPlatformUserPackage "package";
  jq = crossPlatformUserPackage "package";
  kitty = crossPlatformUserPackage "package";
  lazydocker = crossPlatformUserPackage "package";
  lazygit = crossPlatformUserPackage "package";
  lolcat = crossPlatformUserPackage "package";
  mikusays = crossPlatformUserPackage "custom";
  neovim = crossPlatformUserPackage "integration-heavy";
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
  hyprland = linuxDesktopUser "desktop-session";
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
      "This package currently relies on NixOS-side integration and is not implemented on this backend.";
    unsupportedSuggestion =
      "Use a NixOS backend for automatic setup, or configure gnome-keyring manually in your session.";
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
}
