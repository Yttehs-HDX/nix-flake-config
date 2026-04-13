{ ... }:
{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.codex ];

  programs.zsh.initContent = lib.mkIf config.programs.zsh.enable (lib.mkAfter ''
    eval "$(codex completion zsh)"
  '');
}
