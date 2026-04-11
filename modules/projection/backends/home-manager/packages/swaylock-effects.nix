{ input, ... }:
{ config, lib, pkgs, ... }:
let
  desktopTheme =
    if input.theme != null then input.theme.desktop or null else null;
  swaylockTheme = if desktopTheme != null then
    desktopTheme.consumers.swaylockEffects or null
  else
    null;
  stripHash = color: lib.removePrefix "#" color;
  swaylockSettings = {
    screenshots = true;
    clock = true;
    font = swaylockTheme.font.family or null;
    "font-size" = swaylockTheme.font.size or null;
    "text-color" = stripHash (swaylockTheme.colors.text or "#b4befe");
    "text-caps-lock-color" =
      stripHash (swaylockTheme.colors.capsLock or "#f5c2e7");
    indicator = true;
    "indicator-radius" = swaylockTheme.indicator.radius or 100;
    "indicator-thickness" = swaylockTheme.indicator.thickness or 7;
    "effect-blur" = swaylockTheme.effects.blur or "25x25";
    "effect-vignette" = swaylockTheme.effects.vignette or "0.5:0.5";
    "ring-color" = stripHash (swaylockTheme.colors.ring or "#b4befe");
    "key-hl-color" = stripHash (swaylockTheme.colors.keyHighlight or "#f5c2e7");
    "line-color" = swaylockTheme.colors.line or "00000000";
    "inside-color" = swaylockTheme.colors.inside or "00000088";
    "separator-color" = swaylockTheme.colors.separator or "00000000";
  };
  swaylockThemed = pkgs.writeShellApplication {
    name = "swaylock-themed";
    runtimeInputs = [ config.programs.swaylock.package ];
    text = ''
      exec ${lib.getExe config.programs.swaylock.package} "$@"
    '';
  };
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
  } // lib.optionalAttrs (swaylockTheme != null) {
    settings = lib.filterAttrs (_: value: value != null) swaylockSettings;
  };

  home.packages = [ swaylockThemed ];
}
