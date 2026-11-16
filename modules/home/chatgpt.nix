{ inputs, ... }:

{
  imports = [ inputs.codex-desktop-linux.homeManagerModules.default ];

  programs.codexDesktopLinux.enable = true;
  home.sessionVariables.CODEX_LINUX_DISABLE_USAGE_REPORTING = "1";
}
