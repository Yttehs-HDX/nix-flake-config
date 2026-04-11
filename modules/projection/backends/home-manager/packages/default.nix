{ lib, input }:
let
  registry = {
    android-tools = import ./android-tools.nix;
    asciiquarium = import ./asciiquarium.nix;
    bat = import ./bat.nix;
    blueman = import ./blueman.nix;
    brightnessctl = import ./brightnessctl.nix;
    btop = import ./btop.nix;
    cava = import ./cava.nix;
    cbonsai = import ./cbonsai.nix;
    clash-verge-rev = import ./clash-verge-rev.nix;
    cmatrix = import ./cmatrix.nix;
    codex = import ./codex.nix;
    command-not-found = import ./command-not-found.nix;
    copilot-cli = import ./copilot-cli.nix;
    cryptsetup = import ./cryptsetup.nix;
    dig = import ./dig.nix;
    direnv = import ./direnv.nix;
    duf = import ./duf.nix;
    embedded-dev = import ./embedded-dev.nix;
    eza = import ./eza.nix;
    fastfetch = import ./fastfetch.nix;
    feishu = import ./feishu.nix;
    fcitx5 = import ./fcitx5.nix;
    figlet = import ./figlet.nix;
    file = import ./file.nix;
    fzf = import ./fzf.nix;
    gh = import ./gh.nix;
    git = import ./git.nix;
    gnome-keyring = import ./gnome-keyring.nix;
    google-chrome = import ./google-chrome.nix;
    hexecute = import ./hexecute.nix;
    hello = import ./hello.nix;
    hmcl = import ./hmcl.nix;
    htop = import ./htop.nix;
    huggingface-hub = import ./huggingface-hub.nix;
    hyprland = import ./hyprland.nix;
    jq = import ./jq.nix;
    jetbrains-toolbox = import ./jetbrains-toolbox.nix;
    kdeconnect = import ./kdeconnect.nix;
    kitty = import ./kitty.nix;
    krita = import ./krita.nix;
    lazydocker = import ./lazydocker.nix;
    lazygit = import ./lazygit.nix;
    libnotify = import ./libnotify.nix;
    lolcat = import ./lolcat.nix;
    mikusays = import ./mikusays.nix;
    neovim = import ./neovim.nix;
    net-tools = import ./net-tools.nix;
    network-manager = import ./network-manager.nix;
    nerd-fonts-jetbrains-mono = import ./nerd-fonts-jetbrains-mono.nix;
    niri = import ./niri.nix;
    nix-index = import ./nix-index.nix;
    nixfmt-classic = import ./nixfmt-classic.nix;
    nmap = import ./nmap.nix;
    noto-fonts = import ./noto-fonts.nix;
    noto-fonts-cjk-sans = import ./noto-fonts-cjk-sans.nix;
    noto-fonts-cjk-serif = import ./noto-fonts-cjk-serif.nix;
    noto-fonts-emoji-blob-bin = import ./noto-fonts-emoji-blob-bin.nix;
    obs-studio = import ./obs-studio.nix;
    ocr = import ./ocr.nix;
    onlyoffice = import ./onlyoffice.nix;
    osu-lazer-bin = import ./osu-lazer-bin.nix;
    pipewire = import ./pipewire.nix;
    pipes-rs = import ./pipes-rs.nix;
    playerctl = import ./playerctl.nix;
    poppler-utils = import ./poppler-utils.nix;
    pulseaudio = import ./pulseaudio.nix;
    qq = import ./qq.nix;
    ripgrep = import ./ripgrep.nix;
    rofi = import ./rofi.nix;
    rofimoji = import ./rofimoji.nix;
    scrcpy = import ./scrcpy.nix;
    seahorse = import ./seahorse.nix;
    tgpt = import ./tgpt.nix;
    tesseract = import ./tesseract.nix;
    tldr = import ./tldr.nix;
    tmux = import ./tmux.nix;
    translate-shell = import ./translate-shell.nix;
    udisks2 = import ./udisks2.nix;
    universal-android-debloater = import ./universal-android-debloater.nix;
    unrar = import ./unrar.nix;
    unzip = import ./unzip.nix;
    vlc = import ./vlc.nix;
    vscode = import ./vscode.nix;
    waybar = import ./waybar.nix;
    wechat = import ./wechat.nix;
    wget = import ./wget.nix;
    xdg = import ./xdg.nix;
    yazi = import ./yazi.nix;
    zip = import ./zip.nix;
    zsh = import ./zsh.nix;
  };

  resolve = packageId: definition:
    if builtins.hasAttr packageId registry then
      registry.${packageId} { inherit input definition; }
    else
      throw
      "Unsupported Home Manager package `${packageId}` on `${input.relationId}`.";
in map (packageId: resolve packageId input.packages.home.${packageId})
(lib.sort lib.lessThan (builtins.attrNames input.packages.home))
