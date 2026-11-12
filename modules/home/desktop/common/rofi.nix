{
  config,
  lib,
  pkgs,
  ...
}:

let
  clipboardMode = pkgs.writeShellScript "rofi-clipboard" ''
    case "$ROFI_RETV" in
      0)
        printf '\0no-custom\x1ftrue\n'
        exec ${pkgs.cliphist}/bin/cliphist -preview-width 2048 list
        ;;
      1) exec ${pkgs.cliphist}/bin/cliphist-rofi "$1" >/dev/null ;;
    esac
  '';
in
{
  xdg.configFile."rofi/file-browser".text = ''
    dir "${config.home.homeDirectory}"
    depth 6
    no-descend
    hide-parent
    disable-thumbnails
    exclude node_modules
    exclude target
    exclude result
    exclude result-*
  '';

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-file-browser ];
    modes = [
      "drun"
      {
        name = "clipboard";
        path = "${clipboardMode}";
      }
      "window"
      "filebrowser"
      "run"
      {
        name = "emoji";
        path = lib.getExe pkgs.rofimoji;
      }
    ];
    terminal = "kitty";

    extraConfig = {
      combi-modes = "drun,clipboard:${clipboardMode},file-browser-extended";
      display-combi = "󰍉 全局搜索";
      display-file-browser-extended = "󰈞 Files";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      hide-scrollbar = false;
      kb-mode-next = "Tab,Shift+Right";
      kb-mode-previous = "ISO_Left_Tab,Shift+Left";
      kb-element-next = "";
      kb-element-prev = "";
      display-drun = "󰀻 Apps";
      display-clipboard = "󰅌 Clipboard";
      display-emoji = "󰞅 Emoji";
      display-run = "󰐊 Run";
      display-window = "󰖲 Window";
      display-filebrowser = "󰉋 File";
      sidebar-mode = true;
    };
  };
}
