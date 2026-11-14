{ lib, pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
        fcitx5-pinyin-moegirl
        fcitx5-mozc
      ];
    };
  };

  # Do not replace the entire fcitx5 directory: it contains user dictionaries.
  home.activation.fcitx5Theme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.config/fcitx5/conf/classicui.conf" ] && \
       [ ! -L "$HOME/.config/fcitx5/conf/classicui.conf" ]; then
      run install -Dm600 ${pkgs.writeText "fcitx5-classicui.conf" "Theme=dms\nDarkTheme=dms\n"} \
        "$HOME/.config/fcitx5/conf/classicui.conf"
    fi
  '';
}
