{ inputs, lib, projection }: {
  nixosConfigurations = import ./nixos.nix { inherit inputs lib projection; };
  darwinConfigurations = import ./darwin.nix { inherit inputs lib projection; };
  homeConfigurations =
    import ./home-manager.nix { inherit inputs lib projection; };
}
