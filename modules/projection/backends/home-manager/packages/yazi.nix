{ input, ... }:
{ ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = input.current.user.preferences.shell == "zsh";
  };
}
