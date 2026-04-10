{ inputs, lib, pipeline, projection }: {
  nixosConfigurations =
    import ./nixos.nix { inherit inputs lib pipeline projection; };
  darwinConfigurations =
    import ./darwin.nix { inherit inputs lib pipeline projection; };
  homeConfigurations =
    import ./home-manager.nix { inherit inputs lib pipeline projection; };
}
