{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [ inputs.dux-files.nixosModules.default ];

  programs.dux-files = {
    enable = true;
    package = inputs.dux-files.packages.${system}.default;
    quickshell.package = inputs.nixpkgs-unstable.legacyPackages.${system}.quickshell;
    portal = {
      enable = true;
      preferred = true;
      desktop = "niri";
    };
  };

  # niri's module also sets a FileChooser fallback when Nautilus is disabled.
  xdg.portal.config.niri."org.freedesktop.impl.portal.FileChooser" = lib.mkForce "dfiles";
}
