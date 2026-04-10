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
    theme.enable = true;
  };

  software = {
    git = { };
    direnv = { };
    jq = { };
    btop = { };
    kitty.settings = {
      fontSize = 14.0;
      backgroundOpacity = 0.9;
      backgroundBlur = 1;
      rememberWindowSize = false;
      shellIntegrationMode = "no_cursor";
    };
  };

  programs = { };
  services = { };
  theme = {
    name = "catppuccin";
    accent = "lavender";
    flavor = "mocha";
    fonts.monospace.family = "JetBrainsMono Nerd Font";
  };
  policy = { };
}
