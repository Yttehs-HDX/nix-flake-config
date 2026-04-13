{ input, ... }:
{ ... }: {
  programs.eza = {
    enable = true;
    enableZshIntegration = input.current.user.preferences.shell == "zsh";
    icons = "always";
    git = true;
  };
}
