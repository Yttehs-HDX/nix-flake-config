{ inputs, pkgs, ... }:

let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = [
      (import ../../../../packages/latchshot { inherit inputs pkgs; })
      pkgs.coreutils
      pkgs.swappy
    ];
    text = ''
      img=$(mktemp --suffix=.png)
      trap 'rm -f "$img"' EXIT
      latchshot --prefer-crop --no-notify --output "$img"
      [[ -s "$img" ]] || exit 0
      swappy -f - < "$img"
    '';
  };
in
{
  home.packages = [ screenshot ];

  xdg.desktopEntries.niri-screenshot = {
    name = "截图";
    genericName = "Screenshot";
    exec = "${screenshot}/bin/screenshot";
    icon = "applets-screenshooter";
    categories = [ "Utility" ];
    settings.Keywords = "截屏;区域截图;窗口截图;capture;";
  };
}
