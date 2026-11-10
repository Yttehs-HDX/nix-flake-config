{ inputs, lib, pkgs, ... }:

let
  pinViewer = import ../../../../packages/omasnap-pin/package.nix { inherit pkgs; };
  pin = pkgs.writeShellApplication {
    name = "niri-pin-image";
    runtimeInputs = with pkgs; [ coreutils libnotify wl-clipboard ];
    text = ''
      # Match the viewer's private snapshot convention so the last pin/editor
      # holding the image cleans it up, including when a pin reopens in an editor.
      umask 077
      dir="$XDG_RUNTIME_DIR/omasnap"
      mkdir -p "$dir"
      nonce=$(od -An -N8 -tx1 /dev/urandom | tr -d ' \n')
      image="$dir/pin-$$-1-$nonce.png"
      (set -C; : > "$image")
      trap 'rm -f "$image"' EXIT

      case "''${1:---clipboard}" in
        --clipboard)
          if ! wl-paste --no-newline --type image/png > "$image"; then
            notify-send "钉图" "请先复制 PNG 图片，或搜：截图并钉住。"
            exit 0
          fi
          ;;
        --capture)
          ${if inputs ? latchshot then ''
            ${lib.getExe (import ../../../../packages/latchshot { inherit inputs pkgs; })} \
              --prefer-crop --no-notify --output "$image"
          '' else ''
            region=$(${pkgs.slurp}/bin/slurp) || exit 0
            ${pkgs.grim}/bin/grim -g "$region" "$image"
          ''}
          ;;
        *) echo "Usage: niri-pin-image [--clipboard|--capture]" >&2; exit 2 ;;
      esac

      [[ -s "$image" ]] || exit 0
      ${pinViewer}/bin/omasnap --pin "$image"
      trap - EXIT
    '';
  };
in
{
  home.packages = [ pin ];
  xdg.desktopEntries = {
    niri-pin-clipboard = {
      name = "钉住剪贴板图片";
      genericName = "Pin Clipboard Screenshot";
      exec = "${lib.getExe pin} --clipboard";
      icon = "edit-paste";
      categories = [ "Utility" ];
      settings.Keywords = "钉图;参考图;置顶;pin;clipboard;";
    };
    niri-pin-capture = {
      name = "截图并钉住";
      genericName = "Capture and Pin";
      exec = "${lib.getExe pin} --capture";
      icon = "applets-screenshooter";
      categories = [ "Utility" ];
      settings.Keywords = "钉图;参考图;置顶;pin;screenshot;";
    };
  };
}
