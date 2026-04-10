{ lib, instances }:
let
  current = import ./current.nix { inherit lib instances; };
  projectionInputs = import ./projection-inputs.nix { inherit lib current; };
in { inherit current projectionInputs; }
