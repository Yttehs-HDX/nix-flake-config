{ current, lib }:
let
  enabled = current.effectiveCapabilities.theme.enable;
  sourceTheme = current.user.theme;
  themeName = sourceTheme.name or null;
  desktopEnabled = current.effectiveCapabilities.desktop.enable;
  platformSystem = current.host.platform.system;
  resolvedTheme = if !enabled || themeName == null then
    { }
  else if themeName == "catppuccin" then
    import ./resources/themes/catppuccin.nix {
      theme = sourceTheme;
      inherit desktopEnabled platformSystem lib;
    }
  else
    sourceTheme;
in if !enabled then null else sourceTheme // resolvedTheme
