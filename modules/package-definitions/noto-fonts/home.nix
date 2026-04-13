{ input, ... }:
{ pkgs, ... }:
let theme = if input.theme != null then input.theme else { fonts = { }; };
in {
  home.packages = [ pkgs.noto-fonts ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ theme.fonts.sans.family or "Noto Sans" ];
      serif = [ theme.fonts.sans.family or "Noto Serif" ];
    };
  };
}
