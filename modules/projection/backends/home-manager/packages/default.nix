{ lib, input }:
let
  # Load package definitions
  packageDefinitions = import ../../../../package-definitions { inherit lib; };

  # Build registry from definitions + legacy entries
  # Definitions take precedence over legacy hardcoded imports
  definitionRegistry = builtins.mapAttrs (id: def:
    let backendPath = def.backends.home-manager.home or null;
    in if backendPath == null then null else import backendPath)
    packageDefinitions;

  # Legacy inline entries (to be migrated to package definitions)
  legacyRegistry = {
    # android-tools = import ./android-tools.nix;  # Now in definitions
    # asciiquarium = import ./asciiquarium.nix;  # Now in definitions
    # bat = import ./bat.nix;  # Now in definitions
    # blueman = import ./blueman.nix;  # Now in definitions
    # brightnessctl = import ./brightnessctl.nix;  # Now in definitions
    # btop = import ./btop.nix;  # Now in definitions
    # cava = import ./cava.nix;  # Now in definitions
    # cbonsai = import ./cbonsai.nix;  # Now in definitions
    # clash-verge-rev = import ./clash-verge-rev.nix;  # Now in definitions
    # cliphist = import ./cliphist.nix;  # Now in definitions
    # cmatrix = import ./cmatrix.nix;  # Now in definitions
    # codex = import ./codex.nix;  # Now in definitions
    # cryptsetup = import ./cryptsetup.nix;  # Now in definitions
    # dig = import ./dig.nix;  # Now in definitions
    # direnv = import ./direnv.nix;  # Now in definitions
    # duf = import ./duf.nix;  # Now in definitions
    embedded-dev =
      if input.backend.type == "nixos" then null else import ./embedded-dev.nix;
    # eza = import ./eza.nix;  # Now in definitions
    # fastfetch = import ./fastfetch.nix;  # Now in definitions
    # feishu = import ./feishu.nix;  # Now in definitions
    # fcitx5 = import ./fcitx5.nix;  # Now in definitions
    # figlet = import ./figlet.nix;  # Now in definitions
    # file = import ./file.nix;  # Now in definitions
    # fzf = import ./fzf.nix;  # Now in definitions
    # gh = import ./gh.nix;  # Now in definitions
    # git = import ./git.nix;  # Now in definitions
    # github-copilot-cli = import ./github-copilot-cli.nix;  # Now in definitions
    gnome-keyring = if input.backend.type == "nixos" then
      null
    else
      import ./gnome-keyring.nix;
    # google-chrome = import ./google-chrome.nix;  # Now in definitions
    # grimblast = import ./grimblast.nix;  # Now in definitions
    # hexecute = import ./hexecute.nix;  # Now in definitions
    hello = import ./hello.nix;
    # hmcl = import ./hmcl.nix;  # Now in definitions
    # htop = import ./htop.nix;  # Now in definitions
    # huggingface-hub = import ./huggingface-hub.nix;  # Now in definitions
    # hypridle = import ./hypridle.nix;  # Now in definitions
    # hyprpicker = import ./hyprpicker.nix;  # Now in definitions
    # hyprland = import ./hyprland.nix;  # Now in definitions
    # hyprpolkitagent = import ./hyprpolkitagent.nix;  # Now in definitions
    # jq = import ./jq.nix;  # Now in definitions
    # jetbrains-toolbox = import ./jetbrains-toolbox.nix;  # Now in definitions
    # kdeconnect = import ./kdeconnect.nix;  # Now in definitions
    # kitty = import ./kitty.nix;  # Now in definitions
    # krita = import ./krita.nix;  # Now in definitions
    # lazydocker = import ./lazydocker.nix;  # Now in definitions
    # lazygit = import ./lazygit.nix;  # Now in definitions
    # libnotify = import ./libnotify.nix;  # Now in definitions
    # lolcat = import ./lolcat.nix;  # Now in definitions
    # mikusays = import ./mikusays.nix;  # Now in definitions
    neovim = null;
    # nixvim = import ./nixvim.nix;  # Now in definitions
    # net-tools = import ./net-tools.nix;  # Now in definitions
    # network-manager = import ./network-manager.nix;  # Now in definitions
    # nerd-fonts-jetbrains-mono = import ./nerd-fonts-jetbrains-mono.nix;  # Now in definitions
    # nix-index = import ./nix-index.nix;  # Now in definitions
    # nixfmt-classic = import ./nixfmt-classic.nix;  # Now in definitions
    # nmap = import ./nmap.nix;  # Now in definitions
    # noto-fonts = import ./noto-fonts.nix;  # Now in definitions
    # noto-fonts-cjk-sans = import ./noto-fonts-cjk-sans.nix;  # Now in definitions
    # noto-fonts-cjk-serif = import ./noto-fonts-cjk-serif.nix;  # Now in definitions
    # noto-fonts-emoji-blob-bin = import ./noto-fonts-emoji-blob-bin.nix;  # Now in definitions
    # obs-studio = import ./obs-studio.nix;  # Now in definitions
    # ocr = import ./ocr.nix;  # Now in definitions
    # onlyoffice = import ./onlyoffice.nix;  # Now in definitions
    # osu-lazer-bin = import ./osu-lazer-bin.nix;  # Now in definitions
    pipewire =
      if input.backend.type == "nixos" then null else import ./pipewire.nix;
    # pipes-rs = import ./pipes-rs.nix;  # Now in definitions
    # playerctl = import ./playerctl.nix;  # Now in definitions
    # poppler-utils = import ./poppler-utils.nix;  # Now in definitions
    # pulseaudio = import ./pulseaudio.nix;  # Now in definitions
    # qq = import ./qq.nix;  # Now in definitions
    # ripgrep = import ./ripgrep.nix;  # Now in definitions
    # rofi = import ./rofi.nix;  # Now in definitions
    # rofimoji = import ./rofimoji.nix;  # Now in definitions
    # scrcpy = import ./scrcpy.nix;  # Now in definitions
    # seahorse = import ./seahorse.nix;  # Now in definitions
    # swaylock-effects = import ./swaylock-effects.nix;  # Now in definitions
    # swaync = import ./swaync.nix;  # Now in definitions
    # swww = import ./swww.nix;  # Now in definitions
    # swappy = import ./swappy.nix;  # Now in definitions
    # tgpt = import ./tgpt.nix;  # Now in definitions
    # tesseract = import ./tesseract.nix;  # Now in definitions
    # tldr = import ./tldr.nix;  # Now in definitions
    # tmux = import ./tmux.nix;  # Now in definitions
    # translate-shell = import ./translate-shell.nix;  # Now in definitions
    # udisks2 = import ./udisks2.nix;  # Now in definitions
    # universal-android-debloater = import ./universal-android-debloater.nix;  # Now in definitions
    # unrar = import ./unrar.nix;  # Now in definitions
    # unzip = import ./unzip.nix;  # Now in definitions
    # vlc = import ./vlc.nix;  # Now in definitions
    # vscode = import ./vscode.nix;  # Now in definitions
    # waybar = import ./waybar.nix;  # Now in definitions
    # wechat = import ./wechat.nix;  # Now in definitions
    # wget = import ./wget.nix;  # Now in definitions
    # wl-clipboard = import ./wl-clipboard.nix;  # Now in definitions
    # xdg = import ./xdg.nix;  # Now in definitions
    # yazi = import ./yazi.nix;  # Now in definitions
    # zip = import ./zip.nix;  # Now in definitions
    # zsh = import ./zsh.nix;  # Now in definitions
  };

  # Merge definitions (preferred) with legacy entries (fallback)
  registry = legacyRegistry // definitionRegistry;

  resolve = packageId: definition:
    if builtins.hasAttr packageId registry then
      if registry.${packageId} == null then
        ({ ... }: { })
      else
        registry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported Home Manager package `${packageId}` on `${input.relationId}`.";
in map (packageId: resolve packageId input.packages.home.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.home))
