{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  initialSettings = pkgs.writeText "dms-initial-settings.json" (
    builtins.toJSON {
      acLockTimeout = 300;
      acMonitorTimeout = 330;
      batteryLockTimeout = 300;
      batteryMonitorTimeout = 330;
      lockBeforeSuspend = true;
      dankLauncherV2IncludeFilesInAll = true;
      dankLauncherV2IncludeFoldersInAll = true;
    }
  );
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

  programs.dank-material-shell = {
    enable = true;
    package = inputs.dms.packages.${system}.default;
    quickshell.package = inputs.nixpkgs-unstable.legacyPackages.${system}.quickshell;
    systemd.enable = true;
    plugins.emojiLauncher.src = inputs.dms-emoji-launcher;
    managePluginSettings = false;
  };

  home.packages = [
    pkgs.util-linux
    pkgs.wtype
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
