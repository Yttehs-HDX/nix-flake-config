{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  profile = import ./profile-eval.nix { inherit lib; };
  pipeline = import ../interfaces/default.nix { inherit lib profile; };
  nixosConfigurations = import ./nixos.nix { inherit inputs lib pipeline; };
  homeConfigurations = import ./home-manager.nix { inherit inputs lib pipeline; };
in {
  inherit profile pipeline nixosConfigurations homeConfigurations;
}
