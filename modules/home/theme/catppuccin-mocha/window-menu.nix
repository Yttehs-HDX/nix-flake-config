{ lib, ... }:

let
  palette = import ./palette.nix;
in
{
  xdg.configFile."wlr-which-key/windows.yaml".text = lib.mkBefore ''
    font: "Noto Sans CJK SC 13"
    background: ${builtins.toJSON palette.base}
    color: ${builtins.toJSON palette.text}
    border: ${builtins.toJSON palette.sky}
  '';
}
