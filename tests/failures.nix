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

  invalidHostStateVersion = builtins.tryEval ((evalProfile {
    users.Alice = { };
    hosts.Workstation = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";
      system.stateVersion = true;
      capabilities.system.enable = true;
      capabilities.home.enable = true;
    };
    relations."Alice@Workstation" = {
      user = "Alice";
      host = "Workstation";
      state.home.stateVersion = "25.05";
    };
  }).profile.hosts.Workstation.system.stateVersion);
in assert !(builtins.tryEval invalidCapability.pipeline.instances).success;
assert !(builtins.tryEval missingReference.pipeline.instances).success;
assert !(builtins.tryEval missingDarwinStateVersion.pipeline.instances).success;
assert !(builtins.tryEval duplicateHostUsername.pipeline.instances).success;
assert !invalidHostStateVersion.success;
true
