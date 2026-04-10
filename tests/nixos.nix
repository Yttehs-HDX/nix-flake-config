{ lib, inputs }:
let
  evaluated = import ./eval-profile.nix {
    inherit lib inputs;
    declarations = {
      users.Alice = {
        meta.displayName = "Alice Example";
        initialHashedPassword =
          "$6$testonlysalt$9OipY8KrPmahUAlTv.LIW2rPsfo4zOwwKACKyaX0j9K3YOgF1.phJdokYGk/Bmoe3dctJoCj1bNPW4UZQcG9e0";
        packages.hello = { };
      };
      hosts.Workstation = {
        backend.type = "nixos";
        platform.system = "x86_64-linux";
        capabilities.system.enable = true;
        capabilities.home.enable = true;
        system.stateVersion = "25.11";
        packages.hello = { };
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
assert projectionInput.account.initialHashedPassword
  == "$6$testonlysalt$9OipY8KrPmahUAlTv.LIW2rPsfo4zOwwKACKyaX0j9K3YOgF1.phJdokYGk/Bmoe3dctJoCj1bNPW4UZQcG9e0";
assert projectionInput.packages.system.hello.enable;
assert projectionInput.packages.home.hello.enable;
assert nixosConfig.config.networking.hostName == "Workstation";
assert nixosConfig.config.users.mutableUsers;
assert nixosConfig.config.users.users.alice.description == "Alice Example";
assert nixosConfig.config.users.users.alice.home == "/home/alice";
assert nixosConfig.config.users.users.alice.initialHashedPassword
  == "$6$testonlysalt$9OipY8KrPmahUAlTv.LIW2rPsfo4zOwwKACKyaX0j9K3YOgF1.phJdokYGk/Bmoe3dctJoCj1bNPW4UZQcG9e0";
assert builtins.elem "wheel" nixosConfig.config.users.users.alice.extraGroups;
assert nixosConfig.config.home-manager.users.alice.home.homeDirectory
  == "/home/alice";
assert nixosConfig.pkgs.config.allowUnfree;
assert builtins.elem nixosConfig.pkgs.hello
  nixosConfig.config.environment.systemPackages;
assert builtins.elem nixosConfig.pkgs.hello
  nixosConfig.config.home-manager.users.alice.home.packages;
true
