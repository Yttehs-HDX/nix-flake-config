{ lib, input }:
let
  registry = {
    bat = import ./bat.nix;
    btop = import ./btop.nix;
    command-not-found = import ./command-not-found.nix;
    direnv = import ./direnv.nix;
    eza = import ./eza.nix;
    fastfetch = import ./fastfetch.nix;
    fcitx5 = import ./fcitx5.nix;
    fzf = import ./fzf.nix;
    gh = import ./gh.nix;
    git = import ./git.nix;
    hello = import ./hello.nix;
    htop = import ./htop.nix;
    hyprland = import ./hyprland.nix;
    jq = import ./jq.nix;
    kitty = import ./kitty.nix;
    nix-index = import ./nix-index.nix;
    nmap = import ./nmap.nix;
    ripgrep = import ./ripgrep.nix;
    rofi = import ./rofi.nix;
    tgpt = import ./tgpt.nix;
    tldr = import ./tldr.nix;
    tmux = import ./tmux.nix;
    waybar = import ./waybar.nix;
    wget = import ./wget.nix;
    xdg = import ./xdg.nix;
    yazi = import ./yazi.nix;
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
