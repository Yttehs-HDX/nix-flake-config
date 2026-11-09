{ pkgs, ... }:

let
  closePanel = "${pkgs.swaynotificationcenter}/bin/swaync-client --close-panel";
in
{
  services.swaync = {
    enable = true;
    package = pkgs.swaynotificationcenter.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./patches/swaync-hide-empty.patch ];
    });
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
        "label#clock"
        "mpris"
        "dnd"
        "volume"
        "buttons-grid"
        "notifications"
        "title"
      ];
      widget-config = {
        "label#clock".text = "";
        dnd.text = "󰂛  勿扰模式";
        volume = {
          label = "󰕾  输出音量";
          show-per-app = true;
          show-per-app-label = true;
          expand-button-label = "应用";
          collapse-button-label = "收起";
          empty-list-label = "暂无播放声音的应用";
        };
        buttons-grid = {
          buttons-per-row = 2;
          actions = [
            {
              label = "󰖩  网络配置";
              update-command = "${pkgs.python3}/bin/python3 ${./scripts/swaync-connections.py} wifi ${pkgs.networkmanager}/bin/nmcli";
              command = "${closePanel} && exec ${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            }
            {
              label = "󰂯  蓝牙设备";
              update-command = "${pkgs.python3}/bin/python3 ${./scripts/swaync-connections.py} bluetooth ${pkgs.bluez}/bin/bluetoothctl";
              command = "${closePanel} && exec ${pkgs.blueman}/bin/blueman-manager";
            }
          ];
        };
        mpris = {
          show-album-art = "never";
          autohide = true;
        };
        title = {
          text = "";
          button-text = "清除全部";
        };
        notifications.vexpand = false;
      };
    };
  };
}
