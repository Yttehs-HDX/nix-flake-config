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
          cava = { };
          cliphist = { };
          fcitx5 = { };
          grimblast = { };
          hypridle = { };
          hyprpicker = { };
          hyprland = { };
          hyprpolkitagent = { };
          rofi = { };
          swaylock-effects = { };
          swaync = { };
          swww = { };
          swappy = { };
          waybar = { };
          wl-clipboard = { };
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
          cliphist = { };
          fcitx5 = { };
          grimblast = { };
          hyprland = { };
          hyprpicker = { };
          rofi = { };
          swaylock-effects = { };
          swaync = { };
          swww = { };
          swappy = { };
          waybar = { };
          wl-clipboard = { };
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
          cliphist = { };
          fcitx5 = { };
          hyprland = { };
          rofi = { };
          swaylock-effects = { };
          swaync = { };
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
assert linuxHome.config.gtk.enable;
assert linuxHome.config.gtk.theme.name == "catppuccin-mocha-lavender-compact";
assert linuxHome.config.qt.enable;
assert linuxHome.config.qt.style.name == "kvantum";
assert linuxHome.config.xdg.configFile."Kvantum/catppuccin-mocha-lavender".source
  != "";
assert linuxHome.pkgs.lib.hasInfix "font-family: IBM Plex Sans"
  linuxHome.config.programs.waybar.style;
assert linuxHome.config.programs.waybar.settings.main.modules-left
  == [ "group/hyprland" "cava" ];
assert linuxHome.config.programs.waybar.settings.main.modules-center
  == [ "group/misc" ];
assert linuxHome.config.programs.waybar.settings.main."custom/hexecute".tooltip-format
  == "魔法使い";
assert linuxHome.config.i18n.inputMethod.type == "fcitx5";
assert linuxHome.config.wayland.windowManager.hyprland.enable;
assert builtins.elem "$mod, TAB, hyprexpo:expo, toggle"
  linuxHome.config.wayland.windowManager.hyprland.settings.bind;
assert builtins.elem ", XF86AudioNext, exec, playerctl next"
  linuxHome.config.wayland.windowManager.hyprland.settings.bindl;
assert builtins.elem ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
  linuxHome.config.wayland.windowManager.hyprland.settings.bindel;
assert linuxHome.config.programs.swaylock.enable;
assert linuxHome.config.programs.swaylock.settings."ring-color" == "b4befe";
assert builtins.elem linuxHome.pkgs.swaylock-effects
  linuxHome.config.home.packages;
assert linuxHome.config.services.swaync.enable;
assert lib.hasInfix ''font-family: "IBM Plex Sans"''
  linuxHome.config.services.swaync.style;
assert linuxHome.config.services.cliphist.enable;
assert linuxHome.config.services.cliphist.package == linuxHome.pkgs.cliphist;
assert linuxHome.config.services.cliphist.clipboardPackage
  == linuxHome.pkgs.wl-clipboard;
assert linuxHome.config.systemd.user.services.cliphist.Service.ExecStart != "";
assert linuxHome.config.services.hypridle.enable;
assert linuxHome.config.services.hypridle.package == linuxHome.pkgs.hypridle;
assert linuxHome.config.services.hypridle.systemdTarget
  == "hyprland-session.target";
assert linuxHome.config.services.hyprpolkitagent.enable;
assert linuxHome.config.services.hyprpolkitagent.package
  == linuxHome.pkgs.hyprpolkitagent;
assert linuxHome.config.services.swww.enable;
assert linuxHome.config.services.swww.package == linuxHome.pkgs.swww;
assert builtins.elem linuxHome.pkgs.grimblast linuxHome.config.home.packages;
assert builtins.elem linuxHome.pkgs.hyprpicker linuxHome.config.home.packages;
assert builtins.elem linuxHome.pkgs.swappy linuxHome.config.home.packages;
assert builtins.elem linuxHome.pkgs.wl-clipboard linuxHome.config.home.packages;
assert builtins.elem "$mod ALT, L, exec, swaylock-themed"
  linuxHome.config.wayland.windowManager.hyprland.settings.bind;
assert builtins.elem
  ", Print, exec, grimblast --freeze save area - | swappy -f -"
  linuxHome.config.wayland.windowManager.hyprland.settings.bind;
assert builtins.elem
  "$mod, W, exec, cliphist list | rofi -dmenu -p '  clipboard' -no-show-icons -display-columns 1,2 | cliphist decode | wl-copy"
  linuxHome.config.wayland.windowManager.hyprland.settings.bind;
assert linuxInput.theme.desktop.provider == "catppuccin";
assert linuxInput.theme.desktop.resources.gtk.theme.name
  == "catppuccin-mocha-lavender-compact";
assert linuxInput.theme.desktop.resources.qt.kvantum.name
  == "catppuccin-mocha-lavender";
assert linuxInput.theme.desktop.resources.gtk.cursorTheme.name
  == "Catppuccin-Mocha-Lavender";
assert linuxInput.theme.desktop.consumers.swaylockEffects.colors.ring
  == "#b4befe";
assert linuxInput.theme.desktop.consumers.swaync.font.family == "IBM Plex Sans";
assert !(builtins.hasAttr "rofi" linuxNoDesktopInput.packages.home);
assert !(builtins.hasAttr "swaylock-effects" linuxNoDesktopInput.packages.home);
assert !(builtins.hasAttr "swaync" linuxNoDesktopInput.packages.home);
assert !linuxNoDesktopHome.config.programs.rofi.enable;
assert !linuxNoDesktopHome.config.programs.waybar.enable;
assert !linuxNoDesktopHome.config.wayland.windowManager.hyprland.enable;
assert !linuxNoDesktopHome.config.i18n.inputMethod.enable;
assert !linuxNoDesktopHome.config.gtk.enable;
assert !linuxNoDesktopHome.config.qt.enable;
assert !linuxNoDesktopHome.config.programs.swaylock.enable;
assert !linuxNoDesktopHome.config.services.swaync.enable;
assert darwinInput.theme.desktop == null;
assert !darwinConfig.config.home-manager.users.alice.programs.rofi.enable;
assert !darwinConfig.config.home-manager.users.alice.programs.waybar.enable;
assert !darwinConfig.config.home-manager.users.alice.wayland.windowManager.hyprland.enable;
assert !darwinConfig.config.home-manager.users.alice.i18n.inputMethod.enable;
assert !darwinConfig.config.home-manager.users.alice.gtk.enable;
assert !darwinConfig.config.home-manager.users.alice.qt.enable;
assert !darwinConfig.config.home-manager.users.alice.programs.swaylock.enable;
assert !darwinConfig.config.home-manager.users.alice.services.swaync.enable;
true
