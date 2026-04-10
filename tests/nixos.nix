{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        meta.displayName = "Alice Example";
        packages.common = [ "hello" ];
      };
      hosts.Workstation = {
        backend.type = "nixos";
        platform.system = "x86_64-linux";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        system.stateVersion = "25.11";
        packages.system = [ "hello" ];
      };
      relations."Alice@Workstation" = {
        user = "Alice";
        host = "Workstation";
        identity.name = "alice";
        membership.extraGroups = [ "wheel" ];
        state.home.stateVersion = "25.05";
      };
    };
  };

  relation = evaluated.projection."Alice@Workstation";
  nixosConfig = evaluated.assembly.nixosConfigurations.Workstation;
  projectionInput = evaluated.pipeline.projectionInputs."Alice@Workstation";
in assert relation.backend.type == "nixos";
assert relation.homeModule != null;
assert builtins.hasAttr "alice" relation.homeModules;
assert projectionInput.identity.homeDirectory == "/home/alice";
assert projectionInput.packages.system == [ "hello" ];
assert projectionInput.packages.home == [ "hello" ];
assert nixosConfig.config.networking.hostName == "Workstation";
assert nixosConfig.config.users.users.alice.description == "Alice Example";
assert nixosConfig.config.users.users.alice.home == "/home/alice";
assert builtins.elem "wheel" nixosConfig.config.users.users.alice.extraGroups;
assert nixosConfig.config.home-manager.users.alice.home.homeDirectory
  == "/home/alice";
assert nixosConfig.pkgs.config.allowUnfree;
assert builtins.elem nixosConfig.pkgs.hello
  nixosConfig.config.environment.systemPackages;
assert builtins.elem nixosConfig.pkgs.hello
  nixosConfig.config.home-manager.users.alice.home.packages;
true
