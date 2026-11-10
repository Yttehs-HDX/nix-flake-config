#!/usr/bin/env bash
set -eu
root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
repo=$(cd "$(dirname "$0")/.." && pwd)
mkdir "$root/bin"
export CLIP_FILE="$root/clipboard"
cat > "$root/bin/dms" <<'STUB'
#!/usr/bin/env bash
[ "$*" = "screenshot --no-confirm --no-file --no-clipboard --no-notify --stdout" ] || exit 2
if [ "${CASE}" = cancel ]; then exit 1; fi
if [ "${CASE}" != empty_image ]; then printf 'image'; fi
STUB
cat > "$root/bin/tesseract" <<'STUB'
#!/usr/bin/env bash
if [ "${CASE}" = ocr_error ]; then exit 1; fi
if [ "${CASE}" = empty_ocr ]; then printf ' \n\r' > "$2.txt"; else printf ' Hello\nworld \r\n' > "$2.txt"; fi
STUB
cat > "$root/bin/trans" <<'STUB'
#!/usr/bin/env bash
cat >/dev/null
if [ "${CASE}" = trans_error ]; then exit 1; fi
if [ "${CASE}" = empty_trans ]; then printf ' \n'; else printf 'translated'; fi
STUB
printf '#!/usr/bin/env bash\ncat > "$CLIP_FILE"\n' > "$root/bin/wl-copy"
printf '#!/usr/bin/env bash\nexit 0\n' > "$root/bin/notify-send"
chmod +x "$root/bin/"*
for name in ocr ocr-trans; do
  nix --extra-experimental-features 'nix-command flakes' eval --impure --raw --expr "builtins.head ((import $repo/modules/home/desktop/common/custom-$name.nix { config = {}; pkgs.writeShellApplication = x: x.text; }).home.packages)" > "$root/$name"
  for CASE in success cancel empty_image ocr_error empty_ocr; do
    export CASE
    printf original > "$CLIP_FILE"
    status=0
    PATH="$root/bin:$PATH" bash -euo pipefail "$root/$name" || status=$?
    expected_status=0
    if [ "$CASE" = cancel ] || [ "$CASE" = ocr_error ]; then expected_status=1; fi
    test "$status" -eq "$expected_status"
    expected=original
    if [ "$CASE" = success ]; then
      if [ "$name" = ocr ]; then expected='Hello world'; else expected=translated; fi
    fi
    test "$(cat "$CLIP_FILE")" = "$expected"
    echo "PASS: $name $CASE"
  done
done
for CASE in trans_error empty_trans; do
  export CASE
  printf original > "$CLIP_FILE"
  status=0
  PATH="$root/bin:$PATH" bash -euo pipefail "$root/ocr-trans" || status=$?
  test "$status" -eq 1
  test "$(cat "$CLIP_FILE")" = original
  echo "PASS: ocr-trans $CASE"
done
