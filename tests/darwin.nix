{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        capabilities.desktop.enable = true;
        packages.hello = { };
      };
      hosts.Mac = {
        backend.type = "nix-darwin";
        platform.system = "aarch64-darwin";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        capabilities.desktop.enable = true;
        system.stateVersion = 6;
        packages.hello = { };
      };
      relations."Alice@Mac" = {
        user = "Alice";
        host = "Mac";
        identity.name = "alice";
        activation.desktop.enable = true;
        state.home.stateVersion = "25.05";
      };
    };
  };

  relation = evaluated.projection."Alice@Mac";
  darwinConfig = evaluated.assembly.darwinConfigurations.Mac;
  projectionInput = evaluated.pipeline.projectionInputs."Alice@Mac";

  unsupportedEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        preferences.shell = "zsh";
        packages = {
          feishu = { };
          qq = { };
          zsh = { };
        };
      };

      hosts.Mac = {
        backend.type = "nix-darwin";
        platform.system = "aarch64-darwin";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        system.stateVersion = 6;
      };

      relations."Alice@Mac" = {
        user = "Alice";
        host = "Mac";
        identity.name = "alice";
        state.home.stateVersion = "25.05";
      };
    };
  };

  unsupportedInput = unsupportedEvaluated.pipeline.projectionInputs."Alice@Mac";
  unsupportedConfig = unsupportedEvaluated.assembly.darwinConfigurations.Mac;
  unsupportedWarnings =
    unsupportedConfig.config.home-manager.users.alice.warnings;
  unsupportedHomePackages = map (drv: drv.name)
    unsupportedConfig.config.home-manager.users.alice.home.packages;
in assert relation.backend.type == "nix-darwin";
assert builtins.length relation.systemModules == 2;
assert relation.homeModule != null;
assert projectionInput.identity.homeDirectory == "/Users/alice";
assert darwinConfig.config.users.users.alice.home == "/Users/alice";
assert darwinConfig.config.home-manager.users.alice.home.homeDirectory
  == "/Users/alice";
assert builtins.elem darwinConfig.pkgs.hello
  darwinConfig.config.environment.systemPackages;
assert builtins.elem darwinConfig.pkgs.hello
  darwinConfig.config.home-manager.users.alice.home.packages;
assert !(builtins.hasAttr "qq" unsupportedInput.packages.home);
assert !(builtins.hasAttr "feishu" unsupportedInput.packages.home);
assert unsupportedInput.unsupportedPackages.home.qq.platform == "darwin";
assert unsupportedInput.unsupportedPackages.home.feishu.backend == "nix-darwin";
assert builtins.any (warning: lib.hasInfix "Package `qq`" warning)
  unsupportedWarnings;
assert builtins.any (warning: lib.hasInfix "Package `feishu`" warning)
  unsupportedWarnings;
assert !(builtins.any (name: lib.hasPrefix "qq-" name) unsupportedHomePackages);
assert !(builtins.any (name: lib.hasPrefix "feishu-" name)
  unsupportedHomePackages);
true
