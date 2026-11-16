{ pkgs, ... }:

{
  home.packages = [ pkgs.wl-clipboard ];
  services.wl-clip-persist.enable = true;
}
