{ lib, profile }:
let
  normalized = import ../normalize/default.nix { inherit lib profile; };
  validation = import ../validate/default.nix { inherit lib normalized; };
  instances = import ../instantiate/default.nix { inherit lib normalized validation; };
  context = import ../context/default.nix { inherit lib instances; };
in {
  inherit profile normalized validation instances;
  current = context.current;
  projectionInputs = context.projectionInputs;
}
