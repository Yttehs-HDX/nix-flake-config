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

  systemPackageEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = { };

      hosts.MacTools = {
        backend.type = "nix-darwin";
        platform.system = "aarch64-darwin";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        system.stateVersion = 6;
        packages = {
          docker.settings.storageDriver = "btrfs";
          locale = { };
          networking = { };
          wireshark.settings.package = "qt";
        };
      };

      relations."Alice@MacTools" = {
        user = "Alice";
        host = "MacTools";
        identity.name = "alice";
        state.home.stateVersion = "25.05";
      };
    };
  };

  unsupportedSystemPackageEvaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = { };

      hosts.MacUnsupported = {
        backend.type = "nix-darwin";
        platform.system = "aarch64-darwin";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        system.stateVersion = 6;
        packages = {
          nix-ld = { };
          virt-manager = { };
        };
      };

      relations."Alice@MacUnsupported" = {
        user = "Alice";
        host = "MacUnsupported";
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
  systemPackageInput =
    systemPackageEvaluated.pipeline.projectionInputs."Alice@MacTools";
  systemPackageConfig =
    systemPackageEvaluated.assembly.darwinConfigurations.MacTools;
  systemWarnings = systemPackageConfig.config.warnings;
  unsupportedSystemInput =
    unsupportedSystemPackageEvaluated.pipeline.projectionInputs."Alice@MacUnsupported";
  unsupportedSystemConfig =
    unsupportedSystemPackageEvaluated.assembly.darwinConfigurations.MacUnsupported;
  unsupportedSystemWarnings = unsupportedSystemConfig.config.warnings;
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
assert builtins.hasAttr "docker" systemPackageInput.packages.system;
assert builtins.hasAttr "locale" systemPackageInput.packages.system;
assert builtins.hasAttr "networking" systemPackageInput.packages.system;
assert builtins.hasAttr "wireshark" systemPackageInput.packages.system;
assert systemPackageConfig.config.networking.hostName == "MacTools";
assert systemPackageConfig.config.networking.localHostName == "MacTools";
assert systemPackageConfig.config.networking.computerName == "MacTools";
assert systemPackageConfig.config.time.timeZone == "Asia/Taipei";
assert systemPackageConfig.config.environment.variables.LANG == "en_US.UTF-8";
assert systemPackageConfig.config.environment.variables.LC_ALL == "en_US.UTF-8";
assert systemPackageConfig.config.system.defaults.NSGlobalDomain.AppleMetricUnits
  == 1;
assert systemPackageConfig.config.system.defaults.NSGlobalDomain.AppleICUForce24HourTime;
assert builtins.elem systemPackageConfig.pkgs.docker
  systemPackageConfig.config.environment.systemPackages;
assert builtins.elem systemPackageConfig.pkgs.docker-compose
  systemPackageConfig.config.environment.systemPackages;
assert builtins.elem systemPackageConfig.pkgs.wireshark-qt
  systemPackageConfig.config.environment.systemPackages;
assert builtins.any (warning:
  lib.hasInfix "Package `docker` on nix-darwin installs the Docker CLI" warning)
  systemWarnings;
assert builtins.any (warning:
  lib.hasInfix "ignores `settings.storageDriver` on nix-darwin" warning)
  systemWarnings;
assert builtins.any (warning:
  lib.hasInfix "Package `locale` on nix-darwin currently projects timezone"
  warning) systemWarnings;
assert builtins.any (warning:
  lib.hasInfix "Package `wireshark` on nix-darwin installs the application"
  warning) systemWarnings;
assert !(builtins.hasAttr "nix-ld" unsupportedSystemInput.packages.system);
assert !(builtins.hasAttr "virt-manager"
  unsupportedSystemInput.packages.system);
assert unsupportedSystemInput.unsupportedPackages.system.nix-ld.platform
  == "darwin";
assert unsupportedSystemInput.unsupportedPackages.system.virt-manager.backend
  == "nix-darwin";
assert builtins.any (warning: lib.hasInfix "Package `nix-ld`" warning)
  unsupportedSystemWarnings;
assert builtins.any (warning: lib.hasInfix "Package `virt-manager`" warning)
  unsupportedSystemWarnings;
true
