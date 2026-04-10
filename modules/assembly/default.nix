{ inputs, lib, pipeline }:
{
  nixosConfigurations = import ./nixos.nix { inherit inputs lib pipeline; };
  homeConfigurations = import ./home-manager.nix { inherit inputs lib pipeline; };
}
