{ backendType }: {
  system = backendType == "nixos" || backendType == "nix-darwin";
  home = backendType == "nixos" || backendType == "home-manager" || backendType
    == "nix-darwin";
}
