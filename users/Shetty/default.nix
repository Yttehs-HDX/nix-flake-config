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

  initialHashedPassword =
    "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";

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
