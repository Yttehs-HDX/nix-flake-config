{
  description = "Layered Nix flake config for Shetty";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      entrypoints = import ./modules/entrypoints { inherit inputs; };
      systems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs systems;
    in {
      lib = {
        profile = entrypoints.profile;
        pipeline = entrypoints.pipeline;
      };

      nixosConfigurations = entrypoints.nixosConfigurations;
      homeConfigurations = entrypoints.homeConfigurations;

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          tests = import ./tests/default.nix {
            inherit lib inputs system;
            profile = entrypoints.profile;
            pipeline = entrypoints.pipeline;
            nixosConfigurations = entrypoints.nixosConfigurations;
            homeConfigurations = entrypoints.homeConfigurations;
          };
          _ = builtins.deepSeq tests tests;
        in {
          architecture = pkgs.runCommand "nix-flake-config-checks" { } ''
            touch "$out"
          '';
        });
    };
}
