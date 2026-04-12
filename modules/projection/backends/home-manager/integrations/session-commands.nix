{ input }:
let
  homePackages = input.packages.home or { };
  hasPackage = packageId: builtins.hasAttr packageId homePackages;
in {
  lock = if hasPackage "swaylock-effects" then "swaylock-themed" else null;

  clipboard = if hasPackage "cliphist" && hasPackage "rofi"
  && hasPackage "wl-clipboard" then
    "cliphist list | rofi -dmenu -p '  clipboard' -no-show-icons -display-columns 1,2 | cliphist decode | wl-copy"
  else
    null;

  screenshot = if hasPackage "grimblast" && hasPackage "swappy" then
    "grimblast --freeze save area - | swappy -f -"
  else
    null;

  colorPicker = if hasPackage "hyprpicker" then
    "hyprpicker --autocopy --format=hex"
  else
    null;
}
