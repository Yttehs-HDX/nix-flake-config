{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = { packages.common = [ "hello" ]; };
      hosts.Workspace = {
        backend.type = "home-manager";
        platform.system = "x86_64-linux";
        capabilities.home.enable = true;
      };
      relations."Alice@Workspace" = {
        user = "Alice";
        host = "Workspace";
        state.home.stateVersion = "25.05";
      };
    };
  };

  relation = evaluated.projection."Alice@Workspace";
  homeConfig = evaluated.assembly.homeConfigurations."alice@Workspace";
  projectionInput = evaluated.pipeline.projectionInputs."Alice@Workspace";
in assert relation.backend.type == "home-manager";
assert builtins.length relation.systemModules == 0;
assert relation.homeModule != null;
assert projectionInput.identity.name == "alice";
assert projectionInput.identity.homeDirectory == "/home/alice";
assert homeConfig.config.home.username == "alice";
assert homeConfig.config.home.homeDirectory == "/home/alice";
assert homeConfig.config.programs.home-manager.enable;
assert builtins.elem homeConfig.pkgs.hello homeConfig.config.home.packages;
true
