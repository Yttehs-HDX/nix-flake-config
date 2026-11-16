#!/usr/bin/env bash
set -eu
root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
repo=$(cd "$(dirname "$0")/.." && pwd)
module=$repo/modules/home/desktop/niri/dux.nix
render() {
  nix --extra-experimental-features 'nix-command flakes' eval --impure --raw --expr "let m = import $module {
    config.xdg.configHome = \"$root/config\";
    inputs = {};
    pkgs.writeText = builtins.toFile;
    lib.escapeShellArg = x: \"'\" + x + \"'\";
    lib.hm.dag.entryAfter = _: x: x;
  }; in m.home.activation.duxInitialSettings" > "$root/activate"
}
run() { "$@"; }
export -f run
render
mkdir -p "$root/config/DankMaterialShell"
printf '{"currentThemeName":"UserChoice"}\n' > "$root/config/DankMaterialShell/settings.json"
printf '{"emojiLauncher":{"enabled":false}}\n' > "$root/config/DankMaterialShell/plugin_settings.json"
bash "$root/activate"
if [ -e "$root/config/dms/settings.json" ] || [ -e "$root/config/dms/plugin_settings.json" ]; then
  echo 'FAIL: initialization masks existing legacy settings with new dms files'
  exit 1
fi
echo 'PASS: legacy settings left for upstream migration'
rm -r "$root/config"
bash "$root/activate"
test -f "$root/config/dms/settings.json"
test ! -L "$root/config/dms/settings.json"
test "$(stat -c %a "$root/config/dms/settings.json")" = 600
printf 'gui-saved\n' > "$root/config/dms/settings.json"
printf 'gui-plugin-saved\n' > "$root/config/dms/plugin_settings.json"
bash "$root/activate"
test "$(cat "$root/config/dms/settings.json")" = gui-saved
test "$(cat "$root/config/dms/plugin_settings.json")" = gui-plugin-saved
echo 'PASS: first-run writable 0600 settings and subsequent GUI changes preserved'
for location in dms DankMaterialShell; do
  rm -r "$root/config"
  mkdir -p "$root/config/$location"
  ln -s "$root/missing" "$root/config/$location/settings.json"
  ln -s "$root/missing-plugin" "$root/config/$location/plugin_settings.json"
  bash "$root/activate"
  test -L "$root/config/$location/settings.json"
  test -L "$root/config/$location/plugin_settings.json"
  if [ "$location" = DankMaterialShell ]; then
    test ! -e "$root/config/dms/settings.json"
    test ! -e "$root/config/dms/plugin_settings.json"
  fi
  echo "PASS: $location dangling symlinks preserved"
done
