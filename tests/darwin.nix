{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        capabilities.desktop.enable = true;
        packages.common = [ "hello" ];
      };
      hosts.Mac = {
        backend.type = "nix-darwin";
        platform.system = "aarch64-darwin";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        capabilities.desktop.enable = true;
        system.stateVersion = 6;
        packages.system = [ "hello" ];
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
true
