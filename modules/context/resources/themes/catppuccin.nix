{ theme, desktopEnabled ? false, platformSystem ? null, lib }:
let
  palettes = {
    latte = {
      rosewater = "#dc8a78";
      flamingo = "#dd7878";
      pink = "#ea76cb";
      mauve = "#8839ef";
      red = "#d20f39";
      maroon = "#e64553";
      peach = "#fe640b";
      yellow = "#df8e1d";
      green = "#40a02b";
      teal = "#179299";
      sky = "#04a5e5";
      sapphire = "#209fb5";
      blue = "#1e66f5";
      lavender = "#7287fd";
      text = "#4c4f69";
      subtext1 = "#5c5f77";
      subtext0 = "#6c6f85";
      overlay2 = "#7c7f93";
      overlay1 = "#8c8fa1";
      overlay0 = "#9ca0b0";
      surface2 = "#acb0be";
      surface1 = "#bcc0cc";
      surface0 = "#ccd0da";
      base = "#eff1f5";
      mantle = "#e6e9ef";
      crust = "#dce0e8";
    };
    frappe = {
      rosewater = "#f2d5cf";
      flamingo = "#eebebe";
      pink = "#f4b8e4";
      mauve = "#ca9ee6";
      red = "#e78284";
      maroon = "#ea999c";
      peach = "#ef9f76";
      yellow = "#e5c890";
      green = "#a6d189";
      teal = "#81c8be";
      sky = "#99d1db";
      sapphire = "#85c1dc";
      blue = "#8caaee";
      lavender = "#babbf1";
      text = "#c6d0f5";
      subtext1 = "#b5bfe2";
      subtext0 = "#a5adce";
      overlay2 = "#949cbb";
      overlay1 = "#838ba7";
      overlay0 = "#737994";
      surface2 = "#626880";
      surface1 = "#51576d";
      surface0 = "#414559";
      base = "#303446";
      mantle = "#292c3c";
      crust = "#232634";
    };
    macchiato = {
      rosewater = "#f4dbd6";
      flamingo = "#f0c6c6";
      pink = "#f5bde6";
      mauve = "#c6a0f6";
      red = "#ed8796";
      maroon = "#ee99a0";
      peach = "#f5a97f";
      yellow = "#eed49f";
      green = "#a6da95";
      teal = "#8bd5ca";
      sky = "#91d7e3";
      sapphire = "#7dc4e4";
      blue = "#8aadf4";
      lavender = "#b7bdf8";
      text = "#cad3f5";
      subtext1 = "#b8c0e0";
      subtext0 = "#a5adcb";
      overlay2 = "#939ab7";
      overlay1 = "#8087a2";
      overlay0 = "#6e738d";
      surface2 = "#5b6078";
      surface1 = "#494d64";
      surface0 = "#363a4f";
      base = "#24273a";
      mantle = "#1e2030";
      crust = "#181926";
    };
    mocha = {
      rosewater = "#f5e0dc";
      flamingo = "#f2cdcd";
      pink = "#f5c2e7";
      mauve = "#cba6f7";
      red = "#f38ba8";
      maroon = "#eba0ac";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      sky = "#89dceb";
      sapphire = "#74c7ec";
      blue = "#89b4fa";
      lavender = "#b4befe";
      text = "#cdd6f4";
      subtext1 = "#bac2de";
      subtext0 = "#a6adc8";
      overlay2 = "#9399b2";
      overlay1 = "#7f849c";
      overlay0 = "#6c7086";
      surface2 = "#585b70";
      surface1 = "#45475a";
      surface0 = "#313244";
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
    };
  };

  flavor = theme.flavor or "mocha";
  accentName = theme.accent or "lavender";
  palette = palettes.${flavor} or palettes.mocha;
  isLinuxDesktop = desktopEnabled && platformSystem != null
    && builtins.match ".*-linux" platformSystem != null;
  capitalize = value:
    if value == "" then
      value
    else
      let
        first = builtins.substring 0 1 value;
        rest = builtins.substring 1 ((builtins.stringLength value) - 1) value;
      in "${lib.toUpper first}${rest}";
  fontValue = value:
    if value == null then
      null
    else if builtins.isAttrs value then
      value.family or null
    else
      value;
  firstNonNull = values:
    let filtered = builtins.filter (value: value != null) values;
    in if filtered == [ ] then null else builtins.head filtered;
  sourceFonts = theme.fonts or { };
  sansFamily = firstNonNull [
    (fontValue (sourceFonts.sans or null))
    (fontValue (sourceFonts.default or null))
    "DejaVu Sans"
  ];
  monospaceFamily = firstNonNull [
    (fontValue (sourceFonts.monospace or null))
    (fontValue (sourceFonts.mono or null))
    "JetBrainsMono Nerd Font"
  ];
  emojiFamily =
    firstNonNull [ (fontValue (sourceFonts.emoji or null)) "Noto Color Emoji" ];
  themeId = "catppuccin-${flavor}-${accentName}";
  cursorVariant = "${flavor}${capitalize accentName}";
  cursorName = "Catppuccin-${capitalize flavor}-${capitalize accentName}";
in {
  name = "catppuccin";
  inherit flavor;
  accent = palette.${accentName} or palette.lavender;
  accentName = accentName;
  fonts = {
    sans = { family = sansFamily; };
    monospace = { family = monospaceFamily; };
    emoji = { family = emojiFamily; };
  };
  palette = palette // {
    accent = palette.${accentName} or palette.lavender;
    accentName = accentName;
  };
  desktop = if !isLinuxDesktop then
    null
  else {
    provider = "catppuccin";
    desktopScoped = true;
    linuxOnly = true;

    resources = {
      palette = palette // {
        accent = palette.${accentName} or palette.lavender;
        accentName = accentName;
      };

      fonts = {
        sans = { family = sansFamily; };
        monospace = { family = monospaceFamily; };
        emoji = { family = emojiFamily; };
      };

      gtk = {
        enable = true;
        preferDark = flavor != "latte";
        font = {
          family = sansFamily;
          size = 12;
        };
        iconTheme = {
          provider = "papirus-icon-theme";
          name = "Papirus-Dark";
        };
        cursorTheme = {
          provider = "catppuccin-cursors";
          variant = cursorVariant;
          name = cursorName;
          size = 24;
        };
        theme = {
          provider = "catppuccin-gtk";
          name = "${themeId}-compact";
          variant = flavor;
          accent = accentName;
          size = "compact";
        };
      };

      qt = {
        enable = true;
        platformTheme = "gtk";
        style = "kvantum";
        kvantum = {
          provider = "catppuccin-kvantum";
          name = themeId;
          variant = flavor;
          accent = accentName;
        };
      };
    };

    consumers = {
      fcitx5 = { addonPackages = [ "catppuccin-fcitx5" ]; };

      hyprland = {
        activeBorder = [ palette.mauve palette.rosewater ];
        inactiveBorder = [ palette.lavender palette.overlay0 ];
      };

      rofi = {
        font = {
          family = sansFamily;
          size = 12;
        };
        window = {
          width = 800;
          height = "480px";
        };
        colors = {
          border = palette.blue;
          background = "${palette.base}bf";
          backgroundLight = "${palette.surface0}b3";
          foreground = palette.text;
          highlight = palette.red;
          accent = "${palette.${accentName} or palette.lavender}cc";
          text = palette.overlay0;
          blue = palette.blue;
        };
      };

      swaylockEffects = {
        font = {
          family = sansFamily;
          size = 64;
        };
        colors = {
          text = palette.lavender;
          capsLock = palette.pink;
          ring = palette.lavender;
          keyHighlight = palette.pink;
          line = "00000000";
          inside = "00000088";
          separator = "00000000";
        };
        indicator = {
          radius = 100;
          thickness = 7;
        };
        effects = {
          blur = "25x25";
          vignette = "0.5:0.5";
        };
      };

      swaync = {
        font = {
          family = sansFamily;
          size = 14;
        };
        colors = palette;
      };

      waybar = {
        font = {
          family = sansFamily;
          size = 17;
        };
        colors = palette // {
          accent = palette.${accentName} or palette.lavender;
          accentName = accentName;
          surface0Alpha = "alpha(@surface0, 0.8)";
          baseAlpha = "alpha(@base, 0.6)";
          borderAlpha = "alpha(@accent, 0.7)";
        };
        calendar = {
          months = palette.rosewater;
          days = palette.pink;
          weeks = palette.teal;
          weekdays = palette.yellow;
          today = palette.red;
        };
      };
    };
  };
}
