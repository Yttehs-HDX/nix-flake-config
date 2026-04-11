{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = { packages.hello = { }; };
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

  darwinEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = { };
      hosts.MacWorkspace = {
        backend.type = "home-manager";
        platform.system = "aarch64-darwin";
        capabilities.home.enable = true;
      };
      relations."Alice@MacWorkspace" = {
        user = "Alice";
        host = "MacWorkspace";
        state.home.stateVersion = "25.05";
      };
    };
  };

  darwinProjectionInput =
    darwinEvaluated.pipeline.projectionInputs."Alice@MacWorkspace";
  darwinHomeConfig =
    darwinEvaluated.assembly.homeConfigurations."alice@MacWorkspace";
in assert relation.backend.type == "home-manager";
assert builtins.length relation.systemModules == 0;
assert relation.homeModule != null;
assert projectionInput.identity.name == "alice";
assert projectionInput.identity.homeDirectory == "/home/alice";
assert homeConfig.config.home.username == "alice";
assert homeConfig.config.home.homeDirectory == "/home/alice";
assert homeConfig.config.programs.home-manager.enable;
assert builtins.elem homeConfig.pkgs.hello homeConfig.config.home.packages;
assert darwinProjectionInput.identity.homeDirectory == "/Users/alice";
assert darwinHomeConfig.config.home.homeDirectory == "/Users/alice";
assert darwinProjectionInput.theme == null;
true
