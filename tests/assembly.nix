{ nixosConfigurations, darwinConfigurations, homeConfigurations }:
let
  nixosConfig = nixosConfigurations."Shetty-Laptop";
  homeConfig = homeConfigurations."shetty@Shetty-Laptop";
in assert builtins.hasAttr "Shetty-Laptop" nixosConfigurations;
assert darwinConfigurations == { };
assert builtins.hasAttr "shetty@Shetty-Laptop" homeConfigurations;
assert nixosConfig.config.virtualisation.docker.enable;
assert nixosConfig.config.programs.nix-ld.enable;
assert nixosConfig.config.programs.virt-manager.enable;
assert nixosConfig.config.virtualisation.libvirtd.enable;
assert nixosConfig.config.programs.wireshark.enable;
assert builtins.elem "docker" nixosConfig.config.users.users.shetty.extraGroups;
assert builtins.elem "libvirtd"
  nixosConfig.config.users.users.shetty.extraGroups;
assert builtins.elem "wireshark"
  nixosConfig.config.users.users.shetty.extraGroups;
assert homeConfig.config.programs.git.enable;
assert homeConfig.config.programs.direnv.nix-direnv.enable;
assert homeConfig.config.programs.zsh.enable;
assert homeConfig.config.programs.eza.enable;
assert homeConfig.config.programs.fzf.enable;
assert homeConfig.config.programs.gh.enable;
assert homeConfig.config.programs.htop.enable;
assert homeConfig.config.programs.kitty.enable;
assert homeConfig.config.programs.kitty.themeFile == "Catppuccin-Mocha";
assert homeConfig.config.programs.nix-index.enable;
assert homeConfig.config.programs.nix-index.enableZshIntegration;
assert homeConfig.config.programs.btop.enable;
assert homeConfig.config.programs.yazi.enable;
assert builtins.elem homeConfig.pkgs.jq homeConfig.config.home.packages;
assert builtins.elem homeConfig.pkgs.fastfetch homeConfig.config.home.packages;
assert builtins.elem homeConfig.pkgs.nmap homeConfig.config.home.packages;
assert builtins.elem homeConfig.pkgs.tgpt homeConfig.config.home.packages;
assert builtins.elem homeConfig.pkgs.tldr homeConfig.config.home.packages;
assert builtins.elem homeConfig.pkgs.wget homeConfig.config.home.packages;
assert homeConfig.config.xdg.configFile."btop/themes/catppuccin-mocha.theme".text
  != "";
assert homeConfig.pkgs.lib.hasInfix "command-not-found.sh"
  homeConfig.config.programs.zsh.initContent;
true
