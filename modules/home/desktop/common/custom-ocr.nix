{ inputs, pkgs, ... }:

let
  ocr = pkgs.writeShellApplication {
    name = "ocr";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnused
      (import ../../../../packages/latchshot { inherit inputs pkgs; })
      pkgs.libnotify
      pkgs.tesseract
      pkgs.wl-clipboard
    ];
    text = ''
      set -e
      img=$(mktemp --suffix=.png /tmp/ocr_XXXXXX)
      txt=$(mktemp /tmp/ocr_XXXXXX)
      trap 'rm -f "$img" "$txt" "$txt.txt"' EXIT

      latchshot --prefer-crop --no-notify --output "$img"
      [[ -s "$img" ]] || exit 0

      tesseract "$img" "$txt" -l chi_sim+eng+jpn --psm 6
      raw=$(cat "$txt.txt" 2>/dev/null || true)

      cleaned=$(printf '%s' "$raw" \
          | tr -d '\r' \
          | paste -s -d ' ' - \
          | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//' \
      )

      if [[ -z "$cleaned" ]]; then
        notify-send --app-name=OCR "未识别到文字" "已保留原剪贴板"
        exit 0
      fi

      printf '%s' "$cleaned" | wl-copy
    '';
  };
in
{
  home.packages = [ ocr ];

  xdg.desktopEntries.niri-ocr = {
    name = "识别屏幕文字";
    genericName = "Screen OCR";
    exec = "${ocr}/bin/ocr";
    icon = "edit-find";
    categories = [ "Utility" ];
    settings.Keywords = "OCR;文字识别;截图取字;识字;";
  };
}
