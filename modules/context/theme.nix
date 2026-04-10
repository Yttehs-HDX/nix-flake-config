{ current }:
let
  enabled = current.effectiveCapabilities.theme.enable;
  sourceTheme = current.user.theme;
  themeName = sourceTheme.name or null;
  resolvedTheme = if !enabled || themeName == null then
    { }
  else if themeName == "catppuccin" then
    import ./resources/themes/catppuccin.nix { theme = sourceTheme; }
  else
    sourceTheme;
in if !enabled then null else sourceTheme // resolvedTheme
