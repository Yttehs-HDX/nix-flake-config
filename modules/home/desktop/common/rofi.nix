{ config, lib, pkgs, ... }:

let
  quickTerminalCommand = "${config.programs.kitty.package}/bin/kitten quick-access-terminal --detach -o focus_policy=on-demand";
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
  xdg.desktopEntries.niri-quick-terminal = {
    name = "Kitty 临时终端";
    genericName = "Quick Access Terminal";
    exec = quickTerminalCommand;
    icon = "kitty";
    categories = [ "System" "TerminalEmulator" ];
    settings.Keywords = "临时终端;下拉终端;terminal;dropdown;quake;";
  };

  xdg.configFile."rofi/scripts/quickterm.sh".source = pkgs.writeShellScript "rofi-quick-terminal" ''
    case "$ROFI_RETV" in
      0)
        printf '\0no-custom\x1ftrue\n'
        printf '调出或收起 Kitty 临时终端\0permanent\x1ftrue\x1ficon\x1fkitty\n'
        ;;
      1) exec ${quickTerminalCommand} </dev/null >/dev/null ;;
    esac
  '';

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
      { name = "clipboard"; path = "${clipboardMode}"; }
      "window"
      "filebrowser"
      "run"
      { name = "emoji"; path = lib.getExe pkgs.rofimoji; }
    ];
    terminal = "kitty";

    extraConfig = {
      combi-modes = "drun,clipboard:${clipboardMode},file-browser-extended";
      display-combi = "全局搜索";
      display-quickterm = "临时终端";
      display-file-browser-extended = "Files";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      hide-scrollbar = false;
      display-drun = "Apps";
      display-clipboard = "Clipboard";
      display-emoji = "Emoji";
      display-run = "Run";
      display-window = "Window";
      display-filebrowser = "File";
      sidebar-mode = true;
    };
  };
}
