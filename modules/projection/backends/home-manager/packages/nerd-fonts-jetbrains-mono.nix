{ input, ... }:
{ pkgs, ... }:
let theme = if input.theme != null then input.theme else { fonts = { }; };
in {
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace =
      [ theme.fonts.monospace.family or "JetBrainsMono Nerd Font" ];
  };
}
