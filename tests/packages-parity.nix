{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        meta.displayName = "Alice Example";
        preferences.shell = "zsh";
        capabilities = {
          desktop.enable = true;
          theme.enable = true;
        };
        theme = {
          name = "catppuccin";
          accent = "lavender";
          flavor = "mocha";
          fonts.sans = "SF Pro";
          fonts.monospace.family = "JetBrainsMono Nerd Font";
        };
        packages = {
          bat = { };
          btop = { };
          direnv = { };
          eza = { };
          fastfetch = { };
          fcitx5 = { };
          fzf = { };
          gh = { };
          git = { };
          htop = { };
          hyprland = { };
          jq = { };
          kitty.settings = {
            fontSize = 14.0;
            backgroundOpacity = 0.9;
            backgroundBlur = 1;
            rememberWindowSize = false;
            shellIntegrationMode = "no_cursor";
          };
          nix-index = { };
          nmap = { };
          ripgrep = { };
          rofi = { };
          tgpt = { };
          tldr = { };
          tmux = { };
          waybar = { };
          wget = { };
          yazi = { };
          zsh = { };
        };
      };

      hosts.Workstation = {
        backend.type = "nixos";
        platform.system = "x86_64-linux";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        capabilities.desktop.enable = true;
        capabilities.userManagement.enable = true;
        system.stateVersion = "25.11";
        packages = {
          docker.settings.storageDriver = "btrfs";
          nix-ld = { };
          virt-manager = { };
          wireshark.settings.package = "qt";
        };
      };

      relations."Alice@Workstation" = {
        user = "Alice";
        host = "Workstation";
        identity.name = "alice";
        membership.extraGroups = [ "wheel" ];
        activation.theme.enable = true;
        state.home.stateVersion = "25.05";
      };
    };
  };

  commandNotFoundEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.TerminalUser = {
        meta.displayName = "Terminal User";
        preferences.shell = "zsh";
        packages = {
          command-not-found = { };
          xdg = { };
          zsh = { };
        };
      };

      hosts.TerminalHost = {
        backend.type = "nixos";
        platform.system = "x86_64-linux";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        capabilities.userManagement.enable = true;
        system.stateVersion = "25.11";
      };

      relations."TerminalUser@TerminalHost" = {
        user = "TerminalUser";
        host = "TerminalHost";
        identity = {
          name = "terminal";
          homeDirectory = "/home/terminal";
        };
        state.home.stateVersion = "25.05";
      };
    };
  };

  nixosConfig = evaluated.assembly.nixosConfigurations.Workstation;
  homeConfig = nixosConfig.config.home-manager.users.alice;
  userConfig = nixosConfig.config.users.users.alice;

  commandNotFoundConfig =
    commandNotFoundEvaluated.assembly.nixosConfigurations.TerminalHost.config.home-manager.users.terminal;
in assert homeConfig.programs.bat.enable;
assert homeConfig.home.sessionVariables.PAGER
  == "${nixosConfig.pkgs.bat}/bin/bat";
assert homeConfig.programs.eza.enable;
assert homeConfig.programs.eza.enableZshIntegration;
assert homeConfig.programs.eza.icons == "always";
assert homeConfig.programs.eza.git;
assert homeConfig.programs.fzf.enable;
assert homeConfig.programs.fzf.enableZshIntegration;
assert homeConfig.programs.gh.enable;
assert homeConfig.programs.gh.gitCredentialHelper.enable;
assert homeConfig.programs.git.enable;
assert homeConfig.programs.direnv.enable;
assert homeConfig.programs.direnv.silent;
assert homeConfig.programs.direnv.nix-direnv.enable;
assert homeConfig.programs.htop.enable;
assert homeConfig.i18n.inputMethod.enable;
assert homeConfig.i18n.inputMethod.type == "fcitx5";
assert builtins.elem nixosConfig.pkgs.catppuccin-fcitx5
  homeConfig.i18n.inputMethod.fcitx5.addons;
assert homeConfig.home.sessionVariables.GLFW_IM_MODULE == "ibus";
assert homeConfig.home.sessionVariables.XMODIFIERS == "@im=fcitx";
assert homeConfig.wayland.windowManager.hyprland.enable;
assert builtins.elem "fcitx5 -d"
  homeConfig.wayland.windowManager.hyprland.settings.exec-once;
assert homeConfig.home.sessionVariables.XDG_CURRENT_DESKTOP == "Hyprland";
assert homeConfig.home.sessionVariables.QT_QPA_PLATFORM == "wayland;xcb";
assert homeConfig.programs.nix-index.enable;
assert homeConfig.programs.nix-index.enableZshIntegration;
assert homeConfig.programs.ripgrep.enable;
assert homeConfig.programs.rofi.enable;
assert homeConfig.programs.rofi.terminal == "kitty";
assert homeConfig.programs.rofi.font == "SF Pro 12";
assert homeConfig.programs.tmux.enable;
assert homeConfig.programs.waybar.enable;
assert homeConfig.programs.waybar.systemd.enable;
assert homeConfig.programs.waybar.settings.main.position == "top";
assert homeConfig.programs.waybar.settings.main."hyprland/workspaces".persistent-workspaces."*"
  == [ 1 2 3 4 5 6 ];
assert lib.hasInfix "@define-color accent" homeConfig.programs.waybar.style;
assert homeConfig.programs.yazi.enable;
assert homeConfig.programs.yazi.enableZshIntegration;
assert homeConfig.programs.zsh.enable;
assert homeConfig.programs.zsh.enableCompletion;
assert homeConfig.programs.zsh.history.size == 100000;
assert homeConfig.programs.zsh.historySubstringSearch.enable;
assert homeConfig.programs.zsh.autosuggestion.enable;
assert homeConfig.programs.zsh.syntaxHighlighting.enable;
assert homeConfig.programs.zsh.shellAliases.ai == "tgpt -i";
assert builtins.elem "tmux" homeConfig.programs.zsh.oh-my-zsh.plugins;
assert homeConfig.programs.zsh.zplug.enable;
assert lib.hasInfix "source ~/.p10k.zsh" homeConfig.programs.zsh.initContent;
assert lib.hasInfix "command-not-found.sh" homeConfig.programs.zsh.initContent;
assert homeConfig.programs.kitty.enable;
assert homeConfig.programs.kitty.themeFile == "Catppuccin-Mocha";
assert homeConfig.programs.kitty.font.name == "JetBrainsMono Nerd Font";
assert homeConfig.programs.kitty.font.size == 14.0;
assert homeConfig.programs.kitty.settings.background_opacity == 0.9;
assert homeConfig.programs.kitty.shellIntegration.enableZshIntegration;
assert homeConfig.programs.btop.enable;
assert homeConfig.xdg.configFile."btop/themes/catppuccin-mocha.theme".text
  != "";
assert builtins.elem nixosConfig.pkgs.fastfetch homeConfig.home.packages;
assert builtins.elem nixosConfig.pkgs.jq homeConfig.home.packages;
assert builtins.elem nixosConfig.pkgs.nmap homeConfig.home.packages;
assert builtins.elem nixosConfig.pkgs.tgpt homeConfig.home.packages;
assert builtins.elem nixosConfig.pkgs.tldr homeConfig.home.packages;
assert builtins.elem nixosConfig.pkgs.wget homeConfig.home.packages;
assert nixosConfig.config.virtualisation.docker.enable;
assert nixosConfig.config.virtualisation.docker.storageDriver == "btrfs";
assert nixosConfig.config.programs.hyprland.enable;
assert nixosConfig.config.programs.nix-ld.enable;
assert nixosConfig.config.programs.virt-manager.enable;
assert nixosConfig.config.virtualisation.libvirtd.enable;
assert nixosConfig.config.virtualisation.spiceUSBRedirection.enable;
assert nixosConfig.config.xdg.portal.enable;
assert builtins.elem nixosConfig.config.programs.hyprland.portalPackage
  nixosConfig.config.xdg.portal.extraPortals;
assert nixosConfig.config.programs.wireshark.enable;
assert nixosConfig.config.programs.wireshark.package
  == nixosConfig.pkgs.wireshark-qt;
assert nixosConfig.config.programs.zsh.enable;
assert userConfig.shell == nixosConfig.pkgs.zsh;
assert builtins.elem "wheel" userConfig.extraGroups;
assert builtins.elem "docker" userConfig.extraGroups;
assert builtins.elem "libvirtd" userConfig.extraGroups;
assert builtins.elem "wireshark" userConfig.extraGroups;
assert commandNotFoundConfig.programs."command-not-found".enable;
assert lib.hasInfix "command_not_found_handler"
  commandNotFoundConfig.programs.zsh.initContent;
assert commandNotFoundConfig.xdg.userDirs.enable;
assert commandNotFoundConfig.xdg.configFile."user-dirs.dirs".text != "";
assert commandNotFoundConfig.home.sessionVariables.XDG_DOWNLOAD_DIR
  == "/home/terminal/Downloads";
true
