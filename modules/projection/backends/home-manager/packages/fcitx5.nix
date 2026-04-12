{ input, definition, ... }:
{ lib, pkgs, ... }:
let
  desktopTheme =
    if input.theme != null then input.theme.desktop or null else null;
  fcitx5Theme = if desktopTheme != null then
    desktopTheme.consumers.fcitx5 or null
  else
    null;
  baseAddons = with pkgs; [
    fcitx5-gtk
    qt6Packages.fcitx5-chinese-addons
    fcitx5-pinyin-zhwiki
    fcitx5-pinyin-moegirl
    fcitx5-mozc
  ];
  extraAddons = definition.settings.addons or [ ];
  themeAddons = map (packageId:
    if packageId == "catppuccin-fcitx5" then
      pkgs.catppuccin-fcitx5
    else
      throw "Unsupported fcitx5 theme addon `${packageId}`.")
    (if fcitx5Theme != null then fcitx5Theme.addonPackages or [ ] else [ ]);
in {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = definition.settings.waylandFrontend or true;
      addons = baseAddons ++ extraAddons ++ themeAddons;

      settings = {
        globalOptions = definition.settings.globalOptions or { };
        inputMethod = definition.settings.inputMethod or { };
        addons = definition.settings.addonSettings or { };
      };
    };
  };
}
