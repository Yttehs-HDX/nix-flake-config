{ input, ... }:
{ ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = input.current.user.preferences.shell == "zsh";
  };
}
