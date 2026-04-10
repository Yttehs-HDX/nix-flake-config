{ input, ... }:
{ ... }: {
  programs.nix-index = {
    enable = true;
    enableZshIntegration = input.current.user.preferences.shell == "zsh";
  };
}
