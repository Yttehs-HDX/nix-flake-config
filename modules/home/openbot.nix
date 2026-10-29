{ inputs, pkgs, ... }:

{
  home.packages = [
    (inputs.openbot.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      # The 0.53.2 AppImage desktop entry no longer includes --no-sandbox.
      extraInstallCommands =
        builtins.replaceStrings [ "'Exec=AppRun --no-sandbox %U'" ] [ "'Exec=AppRun %U'" ]
          old.extraInstallCommands;
    }))
  ];
}
