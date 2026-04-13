{ ... }:
{ pkgs, ... }: {
  services.cliphist = {
    package = pkgs.cliphist;
    clipboardPackage = pkgs.wl-clipboard;
  };
}
