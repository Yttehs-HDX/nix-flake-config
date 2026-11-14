{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  # Full design seed, applied only on first run; Dux Settings owns later edits.
  initialSettings = ./dux-initial-settings.json;
  initialPluginSettings = pkgs.writeText "dms-initial-plugin-settings.json" (
    builtins.toJSON {
      emojiLauncher.enabled = true;
    }
  );
in
{
  imports = [
    inputs.dms.homeModules.default
    inputs.dsearch.homeModules.default
  ];

  programs.dsearch.enable = true;

  # Install Qt platform plugins without managing Dux's writable qtct configs.
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.sessionVariables.QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
  systemd.user.sessionVariables.QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";

  programs.dank-material-shell = {
    enable = true;
    package = inputs.dms.packages.${system}.default.overrideAttrs (old: {
      # QML comes from the upstream flake root, not the Go builder's src.
      postInstall = (old.postInstall or "") + ''
        ${pkgs.patch}/bin/patch --batch --fuzz=0 -p1 \
          -d "$out/share/quickshell/dms" \
          < ${./dux-control-center-four-columns.patch}
      '';
    });
    quickshell.package = inputs.nixpkgs-unstable.legacyPackages.${system}.quickshell;
    systemd.enable = true;
    plugins.emojiLauncher.src = inputs.dms-emoji-launcher;
    managePluginSettings = false;
  };

  home.packages = [
    pkgs.util-linux
    pkgs.wtype
    pkgs.adw-gtk3
    pkgs.papirus-icon-theme
  ];

  # Seed the idle policy and search defaults once, then let the settings UI save changes.
  home.activation.duxInitialSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${lib.escapeShellArg "${config.xdg.configHome}/dms/settings.json"} ] && \
       [ ! -L ${lib.escapeShellArg "${config.xdg.configHome}/dms/settings.json"} ] && \
       [ ! -e ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"} ] && \
       [ ! -L ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/settings.json"} ]; then
      run install -Dm600 ${initialSettings} \
        ${lib.escapeShellArg "${config.xdg.configHome}/dms/settings.json"}
    fi
    if [ ! -e ${lib.escapeShellArg "${config.xdg.configHome}/dms/plugin_settings.json"} ] && \
       [ ! -L ${lib.escapeShellArg "${config.xdg.configHome}/dms/plugin_settings.json"} ] && \
       [ ! -e ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/plugin_settings.json"} ] && \
       [ ! -L ${lib.escapeShellArg "${config.xdg.configHome}/DankMaterialShell/plugin_settings.json"} ]; then
      run install -Dm600 ${initialPluginSettings} \
        ${lib.escapeShellArg "${config.xdg.configHome}/dms/plugin_settings.json"}
    fi
  '';
}
