{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  profile = import ./profile-eval.nix { inherit lib; };
  pipeline = import ../interfaces/default.nix { inherit lib profile; };
  projection = import ../projection/default.nix { inherit lib pipeline; };
  assembly =
    import ../assembly/default.nix { inherit inputs lib pipeline projection; };
in {
  inherit profile pipeline;
  inherit (assembly)
    nixosConfigurations darwinConfigurations homeConfigurations;
}
