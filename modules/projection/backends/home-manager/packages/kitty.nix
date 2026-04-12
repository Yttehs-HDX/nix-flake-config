{ input, definition, ... }:
{ lib, pkgs, ... }:
let
  theme = input.theme;
  flavor = if theme != null then theme.flavor or "mocha" else "mocha";
  usesCatppuccin = theme != null && (theme.name or null) == "catppuccin";
  capitalize = value:
    if value == "" then
      value
    else
      let
        first = lib.toUpper (lib.substring 0 1 value);
        rest = lib.substring 1 (lib.stringLength value - 1) value;
      in "${first}${rest}";
  icat = pkgs.writeShellScriptBin "icat" ''
    exec ${pkgs.kitty}/bin/kitten icat "$@"
  '';
  themeFontFamily =
    if theme != null then theme.fonts.monospace.family or null else null;
  fontFamily = if definition.settings ? fontFamily then
    definition.settings.fontFamily
  else if themeFontFamily != null then
    themeFontFamily
  else
    "JetBrainsMono Nerd Font";
in {
  home.packages = [ icat ];

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;

    font = {
      name = fontFamily;
      size = definition.settings.fontSize or 14.0;
    };

    shellIntegration = {
      mode = definition.settings.shellIntegrationMode or "no_cursor";
      enableZshIntegration = input.current.user.preferences.shell == "zsh";
    };

    settings = {
      background_opacity = definition.settings.backgroundOpacity or 0.9;
      background_blur = definition.settings.backgroundBlur or 1;
      remember_window_size = definition.settings.rememberWindowSize or false;
    };
  } // lib.optionalAttrs usesCatppuccin {
    themeFile = "Catppuccin-${capitalize flavor}";
  };
}
