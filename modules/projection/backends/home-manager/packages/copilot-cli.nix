{ ... }:
{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.copilot-cli ];

  programs.zsh.initContent = lib.mkIf config.programs.zsh.enable (lib.mkAfter ''
    eval "$(copilot completion zsh)"
  '');
}
