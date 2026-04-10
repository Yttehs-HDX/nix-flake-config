{ nixosConfigurations, darwinConfigurations, homeConfigurations }:
let
  nixosConfig = nixosConfigurations."Shetty-Laptop";
  homeConfig = homeConfigurations."shetty@Shetty-Laptop";
in assert builtins.hasAttr "Shetty-Laptop" nixosConfigurations;
assert darwinConfigurations == { };
assert builtins.hasAttr "shetty@Shetty-Laptop" homeConfigurations;
assert nixosConfig.config.virtualisation.docker.enable;
assert nixosConfig.config.programs.nix-ld.enable;
assert nixosConfig.config.programs.wireshark.enable;
assert builtins.elem "docker" nixosConfig.config.users.users.shetty.extraGroups;
assert builtins.elem "wireshark"
  nixosConfig.config.users.users.shetty.extraGroups;
assert homeConfig.config.programs.git.enable;
assert homeConfig.config.programs.direnv.nix-direnv.enable;
assert homeConfig.config.programs.kitty.enable;
assert homeConfig.config.programs.kitty.themeFile == "Catppuccin-Mocha";
assert homeConfig.config.programs.btop.enable;
assert builtins.elem homeConfig.pkgs.jq homeConfig.config.home.packages;
assert homeConfig.config.xdg.configFile."btop/themes/catppuccin-mocha.theme".text
  != "";
true
