{ lib, inputs }:
let
  linuxDesktopEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        preferences.terminal = "foot";
        capabilities = {
          desktop.enable = true;
          theme.enable = true;
        };
        theme = {
          name = "catppuccin";
          accent = "lavender";
          flavor = "mocha";
          fonts.sans = "IBM Plex Sans";
          fonts.monospace.family = "JetBrainsMono Nerd Font";
        };
        packages = {
          fcitx5 = { };
          hyprland = { };
          rofi = { };
          waybar = { };
        };
      };

      hosts.Workspace = {
        backend.type = "home-manager";
        platform.system = "x86_64-linux";
        capabilities = {
          home.enable = true;
          desktop.enable = true;
        };
      };

      relations."Alice@Workspace" = {
        user = "Alice";
        host = "Workspace";
        activation = {
          desktop.enable = true;
          theme.enable = true;
        };
        state.home.stateVersion = "25.05";
      };
    };
  };

  linuxHome =
    linuxDesktopEvaluated.assembly.homeConfigurations."alice@Workspace";
  linuxInput =
    linuxDesktopEvaluated.pipeline.projectionInputs."Alice@Workspace";
  linuxRelation = linuxDesktopEvaluated.projection."Alice@Workspace";

  linuxNoDesktopEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        capabilities = {
          desktop.enable = true;
          theme.enable = true;
        };
        theme = {
          name = "catppuccin";
          accent = "lavender";
          flavor = "mocha";
        };
        packages = {
          fcitx5 = { };
          hyprland = { };
          rofi = { };
          waybar = { };
        };
      };

      hosts.ServerHome = {
        backend.type = "home-manager";
        platform.system = "x86_64-linux";
        capabilities = {
          home.enable = true;
          desktop.enable = true;
        };
      };

      relations."Alice@ServerHome" = {
        user = "Alice";
        host = "ServerHome";
        activation = {
          desktop.enable = false;
          theme.enable = true;
        };
        state.home.stateVersion = "25.05";
      };
    };
  };

  linuxNoDesktopHome =
    linuxNoDesktopEvaluated.assembly.homeConfigurations."alice@ServerHome";
  linuxNoDesktopInput =
    linuxNoDesktopEvaluated.pipeline.projectionInputs."Alice@ServerHome";

  darwinDesktopEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        capabilities = {
          desktop.enable = true;
          theme.enable = true;
        };
        theme = {
          name = "catppuccin";
          accent = "lavender";
          flavor = "mocha";
        };
        packages = {
          fcitx5 = { };
          hyprland = { };
          rofi = { };
          waybar = { };
        };
      };

      hosts.Mac = {
        backend.type = "nix-darwin";
        platform.system = "aarch64-darwin";
        capabilities = {
          system.enable = true;
          home.enable = true;
          desktop.enable = true;
        };
        system.stateVersion = 6;
      };

      relations."Alice@Mac" = {
        user = "Alice";
        host = "Mac";
        activation = {
          desktop.enable = true;
          theme.enable = true;
        };
        state.home.stateVersion = "25.05";
      };
    };
  };

  darwinConfig = darwinDesktopEvaluated.assembly.darwinConfigurations.Mac;
  darwinInput = darwinDesktopEvaluated.pipeline.projectionInputs."Alice@Mac";
in assert builtins.length linuxRelation.systemModules == 0;
assert linuxHome.config.programs.rofi.enable;
assert linuxHome.config.programs.rofi.font == "IBM Plex Sans 12";
assert linuxHome.pkgs.lib.hasInfix "font-family: IBM Plex Sans"
  linuxHome.config.programs.waybar.style;
assert linuxHome.config.i18n.inputMethod.type == "fcitx5";
assert linuxHome.config.wayland.windowManager.hyprland.enable;
assert linuxInput.theme.desktop.provider == "catppuccin";
assert linuxInput.theme.desktop.resources.gtk.theme.name
  == "catppuccin-mocha-lavender-compact";
assert linuxInput.theme.desktop.resources.qt.kvantum.name
  == "catppuccin-mocha-lavender";
assert linuxInput.theme.desktop.resources.gtk.cursorTheme.name
  == "Catppuccin-Mocha-Lavender";
assert !(builtins.hasAttr "rofi" linuxNoDesktopInput.packages.home);
assert !linuxNoDesktopHome.config.programs.rofi.enable;
assert !linuxNoDesktopHome.config.programs.waybar.enable;
assert !linuxNoDesktopHome.config.wayland.windowManager.hyprland.enable;
assert !linuxNoDesktopHome.config.i18n.inputMethod.enable;
assert darwinInput.theme.desktop == null;
assert !darwinConfig.config.home-manager.users.alice.programs.rofi.enable;
assert !darwinConfig.config.home-manager.users.alice.programs.waybar.enable;
assert !darwinConfig.config.home-manager.users.alice.wayland.windowManager.hyprland.enable;
assert !darwinConfig.config.home-manager.users.alice.i18n.inputMethod.enable;
true
