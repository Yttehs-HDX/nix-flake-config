{ pkgs, ... }:

let
  closePanel = "${pkgs.swaynotificationcenter}/bin/swaync-client --close-panel";
in
{
  services.swaync = {
    enable = true;
    settings = {
      control-center-positionX = "right";
      control-center-positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-right = 10;
      control-center-width = 420;
      control-center-height = -1;
      fit-to-screen = false;
      text-empty = "暂无通知";

      widgets = [
        "label#controls"
        "dnd"
        "volume"
        "buttons-grid"
        "mpris"
        "title"
        "notifications"
      ];
      widget-config = {
        "label#controls".text = "控制中心";
        dnd.text = "勿扰模式";
        volume = {
          label = "输出音量";
          show-per-app = true;
          show-per-app-label = true;
          expand-button-label = "分应用";
          collapse-button-label = "收起";
          empty-list-label = "暂无播放声音的应用";
        };
        buttons-grid = {
          buttons-per-row = 2;
          actions = [
            {
              label = "网络配置";
              command = "${closePanel} && exec ${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            }
            {
              label = "蓝牙设备";
              command = "${closePanel} && exec ${pkgs.blueman}/bin/blueman-manager";
            }
          ];
        };
        mpris = {
          show-album-art = "never";
          autohide = true;
        };
        title = {
          text = "通知";
          button-text = "清空通知";
        };
        notifications.vexpand = false;
      };
    };
  };
}
