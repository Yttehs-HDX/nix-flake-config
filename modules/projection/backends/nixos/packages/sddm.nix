{ input, ... }:
{ pkgs, ... }:
let
  theme = input.theme;
  flavor = if theme != null then theme.flavor or "mocha" else "mocha";
  accent = if theme != null then theme.accentName or "lavender" else "lavender";
  catppuccin = pkgs.catppuccin-sddm.override { inherit flavor accent; };
  themeId = "catppuccin-${flavor}-${accent}";
in {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
    ];
    theme = "${catppuccin}/share/sddm/themes/${themeId}";
  };

  environment.systemPackages = [ catppuccin ];
}
