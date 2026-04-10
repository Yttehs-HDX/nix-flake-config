{
  enable = true;

  meta = {
    displayName = "Shetty";
    description = "Primary user profile.";
    tags = [ "primary-user" ];
  };

  preferences = {
    shell = "zsh";
    editor = "nvim";
    terminal = "kitty";
  };

  capabilities = {
    desktop.enable = true;
    development.enable = false;
    theme.enable = false;
  };

  packages.common = [ "hello" ];

  programs = { };
  services = { };
  theme = { };
  policy = { };
}
