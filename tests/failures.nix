{ lib, inputs }:
let
  evalProfile = declarations:
    import ./eval-profile.nix { inherit lib inputs declarations; };

  invalidCapability = evalProfile {
    users.Alice = { };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      system.stateVersion = "25.11";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
      capabilities.desktop.enable = true;
    };
    relations."Alice@Workstation" = {
      user = "Alice";
      host = "Workstation";
      activation.desktop.enable = true;
      state.home.stateVersion = "25.05";
    };
  };

  missingReference = evalProfile {
    users.Alice = { };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      system.stateVersion = "25.11";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
    };
    relations."Alice@Ghost" = {
      user = "Alice";
      host = "Ghost";
      state.home.stateVersion = "25.05";
    };
  };

  missingDarwinStateVersion = evalProfile {
    users.Alice = { capabilities.desktop.enable = true; };
    hosts.Mac = {
      backend.type = "nix-darwin";
      platform.system = "aarch64-darwin";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
      capabilities.desktop.enable = true;
    };
    relations."Alice@Mac" = {
      user = "Alice";
      host = "Mac";
      identity.name = "alice";
      identity.homeDirectory = "/Users/alice";
      activation.desktop.enable = true;
      state.home.stateVersion = "25.05";
    };
  };

  duplicateHostUsername = evalProfile {
    users.Alice = { };
    users.Bob = { };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      system.stateVersion = "25.11";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
    };
    relations."Alice@Workstation" = {
      user = "Alice";
      host = "Workstation";
      identity.name = "shared";
      state.home.stateVersion = "25.05";
    };
    relations."Bob@Workstation" = {
      user = "Bob";
      host = "Workstation";
      identity.name = "shared";
      state.home.stateVersion = "25.05";
    };
  };

  invalidNixosHostStateVersionType = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      system.stateVersion = 25;
      capabilities.system.enable = true;
      capabilities.home.enable = true;
    };
    relations."Alice@Workstation" = {
      user = "Alice";
      host = "Workstation";
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidDarwinHostStateVersionType = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Mac = {
      backend.type = "nix-darwin";
      platform.system = "aarch64-darwin";
      system.stateVersion = "6";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
    };
    relations."Alice@Mac" = {
      user = "Alice";
      host = "Mac";
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidHomeManagerHostSystemStateVersion = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Workspace = {
      backend.type = "home-manager";
      platform.system = "x86_64-linux";
      system.stateVersion = "25.11";
      capabilities.home.enable = true;
    };
    relations."Alice@Workspace" = {
      user = "Alice";
      host = "Workspace";
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidHomeOnlyRelationSystemFields = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Workspace = {
      backend.type = "home-manager";
      platform.system = "x86_64-linux";
      capabilities.home.enable = true;
    };
    relations."Alice@Workspace" = {
      user = "Alice";
      host = "Workspace";
      identity.uid = 1000;
      membership.primaryGroup = "staff";
      membership.extraGroups = [ "wheel" ];
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidDarwinRelationMembershipFields = builtins.tryEval ((evalProfile {
    users.Alice = { };
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
      membership.primaryGroup = "staff";
      membership.extraGroups = [ "admin" ];
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidNixosHomeCapabilityMismatch = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      capabilities.system.enable = true;
      capabilities.home.enable = false;
      system.stateVersion = "25.11";
    };
    relations."Alice@Workstation" = {
      user = "Alice";
      host = "Workstation";
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidDarwinPlatformMismatch = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Mac = {
      backend.type = "nix-darwin";
      platform.system = "x86_64-linux";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
      system.stateVersion = 6;
    };
    relations."Alice@Mac" = {
      user = "Alice";
      host = "Mac";
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidHomeManagerSystemPackages = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Workspace = {
      backend.type = "home-manager";
      platform.system = "x86_64-linux";
      capabilities.home.enable = true;
      packages.system = [ "hello" ];
    };
    relations."Alice@Workspace" = {
      user = "Alice";
      host = "Workspace";
      state.home.stateVersion = "25.05";
    };
  }).pipeline.instances);

  invalidInitialHashedPasswordWithMutableUsersFalse = builtins.tryEval
    ((evalProfile {
      users.Alice = {
        initialHashedPassword =
          "$6$testonlysalt$9OipY8KrPmahUAlTv.LIW2rPsfo4zOwwKACKyaX0j9K3YOgF1.phJdokYGk/Bmoe3dctJoCj1bNPW4UZQcG9e0";
      };
      hosts.Workstation = {
        backend.type = "nixos";
        platform.system = "x86_64-linux";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        system.stateVersion = "25.11";
      };
      relations."Alice@Workstation" = {
        user = "Alice";
        host = "Workstation";
        state.home.stateVersion = "25.05";
      };
    }).assembly.nixosConfigurations.Workstation.config.users.mutableUsers);
in assert !(builtins.tryEval invalidCapability.pipeline.instances).success;
assert !(builtins.tryEval missingReference.pipeline.instances).success;
assert !(builtins.tryEval missingDarwinStateVersion.pipeline.instances).success;
assert !(builtins.tryEval duplicateHostUsername.pipeline.instances).success;
assert !invalidNixosHostStateVersionType.success;
assert !invalidDarwinHostStateVersionType.success;
assert !invalidHomeManagerHostSystemStateVersion.success;
assert !invalidHomeOnlyRelationSystemFields.success;
assert !invalidDarwinRelationMembershipFields.success;
assert !invalidNixosHomeCapabilityMismatch.success;
assert !invalidDarwinPlatformMismatch.success;
assert !invalidHomeManagerSystemPackages.success;
assert invalidInitialHashedPasswordWithMutableUsersFalse.success;

let
  forcedFalse = builtins.tryEval ((evalProfile {
    users.Alice = {
      initialHashedPassword =
        "$6$testonlysalt$9OipY8KrPmahUAlTv.LIW2rPsfo4zOwwKACKyaX0j9K3YOgF1.phJdokYGk/Bmoe3dctJoCj1bNPW4UZQcG9e0";
    };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      capabilities.system.enable = true;
      capabilities.home.enable = true;
      system.stateVersion = "25.11";
    };
    relations."Alice@Workstation" = {
      user = "Alice";
      host = "Workstation";
      state.home.stateVersion = "25.05";
    };
  }).assembly.nixosConfigurations.Workstation.extendModules {
    modules = [{ users.mutableUsers = false; }];
  }).config.system.build.toplevel;
in assert !forcedFalse.success; true
