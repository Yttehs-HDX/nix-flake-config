{ input, definition, ... }:
{ ... }: {
  programs.direnv = {
    enable = true;
    silent = definition.settings.silent or true;
    enableZshIntegration = input.current.user.preferences.shell == "zsh";
    nix-direnv.enable = true;
  };
}
