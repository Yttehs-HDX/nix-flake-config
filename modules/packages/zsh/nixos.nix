{ input, ... }:
{ pkgs, ... }: {
  programs.zsh.enable = true;
  users.users.${input.identity.name}.shell = pkgs.zsh;
}
