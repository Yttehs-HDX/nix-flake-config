{ pkgs, ... }:

{
  home.packages = [ pkgs.rofimoji ];
  xdg.configFile."rofimoji.rc".text = "action = copy\n";
}
