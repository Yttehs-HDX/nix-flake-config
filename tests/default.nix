{ lib, inputs, system, profile, pipeline, nixosConfigurations, homeConfigurations }:
let
  pkgs = import inputs.nixpkgs { inherit system; };
  projection = import ../modules/projection/default.nix {
    inherit lib pkgs;
    context = {
      projectionInputs = pipeline.projectionInputs;
    };
  };

  results = [
    (import ./normalize.nix { inherit pipeline; })
    (import ./instantiate.nix { inherit pipeline; })
    (import ./context.nix { inherit pipeline; })
    (import ./projection.nix { inherit projection; })
    (import ./assembly.nix { inherit nixosConfigurations homeConfigurations; })
  ];
in
builtins.deepSeq results {
  inherit profile pipeline projection;
}
