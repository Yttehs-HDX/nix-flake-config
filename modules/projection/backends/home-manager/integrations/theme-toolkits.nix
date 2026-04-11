{ input }:
{ lib, pkgs, ... }:
let
  desktopTheme =
    if input.theme != null then input.theme.desktop or null else null;
  resources =
    if desktopTheme != null then desktopTheme.resources or { } else { };
  gtkTheme = resources.gtk or null;
  qtTheme = resources.qt or null;
  iniFormat = pkgs.formats.ini { };

  gtkThemePackage = if gtkTheme == null then
    null
  else if gtkTheme.theme.provider == "catppuccin-gtk" then
    pkgs.catppuccin-gtk.override {
      variant = gtkTheme.theme.variant or "mocha";
      accents = [ (gtkTheme.theme.accent or "lavender") ];
      size = gtkTheme.theme.size or "compact";
    }
  else
    null;

  iconThemePackage = if gtkTheme == null then
    null
  else if gtkTheme.iconTheme.provider == "papirus-icon-theme" then
    pkgs.papirus-icon-theme
  else
    null;

  cursorThemePackage = if gtkTheme == null then
    null
  else if gtkTheme.cursorTheme.provider == "catppuccin-cursors" then
    lib.getAttr gtkTheme.cursorTheme.variant pkgs.catppuccin-cursors
  else
    null;

  kvantumPackage = if qtTheme == null then
    null
  else if qtTheme.kvantum.provider == "catppuccin-kvantum" then
    pkgs.catppuccin-kvantum.override {
      variant = qtTheme.kvantum.variant or "mocha";
      accent = qtTheme.kvantum.accent or "lavender";
    }
  else
    null;
in lib.mkMerge [
  (lib.mkIf (gtkTheme != null) {
    gtk = {
      enable = true;
      gtk2.force = true;
      colorScheme = if gtkTheme.preferDark or false then "dark" else "light";
      font = {
        name = gtkTheme.font.family;
        size = gtkTheme.font.size or 12;
      };
      theme = {
        name = gtkTheme.theme.name;
        package = gtkThemePackage;
      };
      iconTheme = {
        name = gtkTheme.iconTheme.name;
        package = iconThemePackage;
      };
      cursorTheme = {
        name = gtkTheme.cursorTheme.name;
        package = cursorThemePackage;
        size = gtkTheme.cursorTheme.size or 24;
      };
    };
  })

  (lib.mkIf (qtTheme != null) {
    qt = {
      enable = true;
      platformTheme.name = qtTheme.platformTheme or "gtk";
      style.name = qtTheme.style or "kvantum";
    };

    xdg.configFile = {
      "Kvantum/${qtTheme.kvantum.name}".source =
        "${kvantumPackage}/share/Kvantum/${qtTheme.kvantum.name}";
      "Kvantum/kvantum.kvconfig".source =
        iniFormat.generate "kvantum.kvconfig" {
          General.theme = qtTheme.kvantum.name;
        };
    };
  })
]
