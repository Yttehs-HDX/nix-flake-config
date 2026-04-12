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

  hostControlledEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = { capabilities.desktop.enable = true; };
      hosts.DesktopWorkspace = {
        backend.type = "home-manager";
        platform.system = "x86_64-linux";
        capabilities = {
          home.enable = true;
          desktop.enable = true;
        };
        packages = { blueman = { }; };
      };
      relations."Alice@DesktopWorkspace" = {
        user = "Alice";
        host = "DesktopWorkspace";
        activation.desktop.enable = true;
        state.home.stateVersion = "25.05";
      };
    };
  };

  hostControlledInput =
    hostControlledEvaluated.pipeline.projectionInputs."Alice@DesktopWorkspace";
  hostControlledHomeConfig =
    hostControlledEvaluated.assembly.homeConfigurations."alice@DesktopWorkspace";

  unsupportedPackageEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        packages = {
          embedded-dev = { };
          brightnessctl = { };
        };
      };
      hosts.StandaloneWorkspace = {
        backend.type = "home-manager";
        platform.system = "x86_64-linux";
        capabilities.home.enable = true;
      };
      relations."Alice@StandaloneWorkspace" = {
        user = "Alice";
        host = "StandaloneWorkspace";
        state.home.stateVersion = "25.05";
      };
    };
  };

  unsupportedProjectionInput =
    unsupportedPackageEvaluated.pipeline.projectionInputs."Alice@StandaloneWorkspace";
  unsupportedHomeConfig =
    unsupportedPackageEvaluated.assembly.homeConfigurations."alice@StandaloneWorkspace";
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
assert hostControlledInput.packages.home.blueman.enable;
assert hostControlledHomeConfig.config.services.blueman-applet.enable;
assert builtins.hasAttr "embedded-dev"
  unsupportedProjectionInput.unsupportedPackages.home;
assert builtins.hasAttr "brightnessctl"
  unsupportedProjectionInput.unsupportedPackages.home;
assert (unsupportedProjectionInput.unsupportedPackages.home.brightnessctl.strategy
  == "skip");
assert builtins.length unsupportedHomeConfig.config.warnings > 0;
true
