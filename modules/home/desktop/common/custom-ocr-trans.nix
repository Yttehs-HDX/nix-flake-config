{ inputs, pkgs, ... }:

let
  ocr-trans = pkgs.writeShellApplication {
    name = "ocr-trans";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
      (import ../../../../packages/latchshot { inherit inputs pkgs; })
      pkgs.libnotify
      pkgs.tesseract
      pkgs.translate-shell
      pkgs.wl-clipboard
    ];
    text = ''
      set -e
      img=$(mktemp --suffix=.png /tmp/ocr-trans_XXXXXX)
      txt=$(mktemp /tmp/ocr-trans_XXXXXX)
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

      if ! printf '%s' "$cleaned" | trans -b :zh-CN > "$txt" || ! grep -q '[^[:space:]]' "$txt"; then
        notify-send --app-name=OCR "未获得译文" "已保留原剪贴板"
        exit 1
      fi
      wl-copy < "$txt"
    '';
  };
in
{
  home.packages = [ ocr-trans ];

  xdg.desktopEntries.niri-ocr-trans = {
    name = "截图翻译";
    genericName = "Translate Screen Text";
    exec = "${ocr-trans}/bin/ocr-trans";
    icon = "accessories-dictionary";
    categories = [ "Utility" ];
    settings.Keywords = "OCR;翻译;译文;translate;";
  };
}
