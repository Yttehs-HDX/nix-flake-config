{ lib, inputs, system, profile, pipeline, nixosConfigurations
, darwinConfigurations, homeConfigurations }:
let
  pkgs = import inputs.nixpkgs { inherit system; };
  projection =
    import ../modules/projection/default.nix { inherit lib pipeline; };

  results = [
    (import ./normalize.nix { inherit pipeline; })
    (import ./instantiate.nix { inherit pipeline; })
    (import ./context.nix { inherit pipeline; })
    (import ./projection.nix { inherit pkgs projection; })
    (import ./assembly.nix {
      inherit nixosConfigurations darwinConfigurations homeConfigurations;
    })
    (import ./packages-parity.nix { inherit lib inputs; })
    (import ./failures.nix { inherit lib inputs; })
    (import ./nixos.nix { inherit lib inputs; })
    (import ./home-manager.nix { inherit lib inputs; })
    (import ./darwin.nix { inherit lib inputs; })
    (import ./desktop.nix { inherit lib inputs; })
  ];
in builtins.deepSeq results { inherit profile pipeline projection; }
