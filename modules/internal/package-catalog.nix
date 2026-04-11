{ lib }:
let
  desktopLinux = kind: {
    inherit kind;
    desktopScoped = true;
    linuxOnly = true;
    requiresDesktop = true;
  };

  catalog = {
    home = {
      bat = { kind = "package"; };
      btop = { kind = "package"; };
      command-not-found = { kind = "environment"; };
      direnv = { kind = "package"; };
      eza = { kind = "package"; };
      fastfetch = { kind = "package"; };
      fcitx5 = desktopLinux "desktop-input-method";
      fzf = { kind = "package"; };
      gh = { kind = "package"; };
      git = { kind = "package"; };
      hello = { kind = "package"; };
      htop = { kind = "package"; };
      hyprland = desktopLinux "desktop-session";
      jq = { kind = "package"; };
      kitty = { kind = "package"; };
      nix-index = { kind = "environment"; };
      nmap = { kind = "package"; };
      ripgrep = { kind = "package"; };
      rofi = desktopLinux "desktop-component";
      tgpt = { kind = "package"; };
      tldr = { kind = "package"; };
      tmux = { kind = "package"; };
      waybar = desktopLinux "desktop-component";
      wget = { kind = "package"; };
      xdg = { kind = "environment"; };
      yazi = { kind = "package"; };
      zsh = { kind = "environment"; };
    };

    system = {
      docker = { kind = "package"; };
      hello = { kind = "package"; };
      nix-ld = { kind = "package"; };
      virt-manager = { kind = "package"; };
      wireshark = { kind = "package"; };
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

  supportedFor = scope: current: packageId:
    let
      metadata = metadataFor scope packageId;
      platformSystem = hostPlatform current;
      isLinuxPlatform = platformSystem != null
        && lib.hasSuffix "-linux" platformSystem;
    in (!(metadata.linuxOnly or false) || isLinuxPlatform)
    && (!(metadata.requiresDesktop or false) || desktopEnabled current);
in { inherit catalog metadataFor supportedFor; }
