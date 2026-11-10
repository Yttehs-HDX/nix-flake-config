{ lib, pkgs, ... }:

let
  command = key: desc: cmd: { inherit key desc cmd; };
  action =
    key: desc: step:
    command key desc "niri msg action ${step}";
  group = key: desc: submenu: { inherit key desc submenu; };
in
{
  home.packages = [ pkgs.wlr-which-key ];

  xdg.configFile."wlr-which-key/windows.yaml".text = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "${name}: ${builtins.toJSON value}") {
      border_width = 2;
      corner_r = 12;
      padding = 16;
      anchor = "center";
      rows_per_column = 5;
      separator = "  ·  ";

      menu = [
        (group "w" "移动当前窗口" [
          (group "s" "送到工作区，焦点留在原处" (
            map (
              i:
              action (toString (
                if i == 10 then 0 else i
              )) "工作区 ${toString i}" "move-window-to-workspace ${toString i} --focus false"
            ) (lib.range 1 10)
          ))
          (group "m" "移到另一显示器" [
            (action "h" "左侧显示器" "move-window-to-monitor-left")
            (action "l" "右侧显示器" "move-window-to-monitor-right")
            (action "k" "上方显示器" "move-window-to-monitor-up")
            (action "j" "下方显示器" "move-window-to-monitor-down")
          ])
        ])
        (group "l" "调整布局" [
          (action "1" "列宽三分之一" "set-column-width 33.333%")
          (action "2" "列宽二分之一" "set-column-width 50%")
          (action "3" "列宽三分之二" "set-column-width 66.667%")
          (action "t" "切换列内标签" "toggle-column-tabbed-display")
          (action "v" "切换浮动与平铺" "toggle-window-floating")
        ])
        (group "f" "切换焦点" [
          (action "j" "向下，到列底后换工作区" "focus-window-or-workspace-down")
          (action "k" "向上，到列顶后换工作区" "focus-window-or-workspace-up")
          (action "p" "上一个工作区" "focus-workspace-previous")
        ])
        (group "p" "钉图" [
          (command "c" "截图并钉住" "niri-pin-image --capture")
          (command "v" "钉住剪贴板图片" "niri-pin-image --clipboard")
        ])
      ];
    }
  );

  xdg.desktopEntries.niri-window-menu = {
    name = "窗口操作";
    genericName = "Window Actions";
    exec = "${lib.getExe pkgs.wlr-which-key} windows";
    icon = "preferences-system-windows";
    categories = [ "Utility" ];
    settings.Keywords = "窗口;布局;列宽;工作区;显示器;window;layout;";
  };
}
