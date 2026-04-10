{
  enable = true;

  user = "Shetty";
  host = "Shetty-Laptop";

  identity = {
    name = "shetty";
    homeDirectory = "/home/shetty";
  };

  membership = {
    extraGroups = [ "wheel" ];
  };

  activation = {
    desktop.enable = true;
    development.enable = false;
    theme.enable = false;
  };

  state.home.stateVersion = "25.05";

  policy = { };
  overrides = { };
}
