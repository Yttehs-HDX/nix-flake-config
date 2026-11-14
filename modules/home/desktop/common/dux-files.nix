{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  imports = [ inputs.dux-files.homeModules.default ];

  programs.dux-files = {
    enable = true;
    package = inputs.dux-files.packages.${system}.default;
    quickshell.package = inputs.nixpkgs-unstable.legacyPackages.${system}.quickshell;
    systemd.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "dev.duxlabs.files.desktop" ];
      "x-scheme-handler/trash" = [ "dev.duxlabs.files.desktop" ];
      "x-scheme-handler/sftp" = [ "dev.duxlabs.files.desktop" ];
      "x-scheme-handler/smb" = [ "dev.duxlabs.files.desktop" ];
    };
  };
}
