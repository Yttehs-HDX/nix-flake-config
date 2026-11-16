{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Applications (GTK file pickers, portals, browsers) write mimeapps.list at
  # runtime, so preserve those writes instead of failing activation.
  home-manager.backupFileExtension = "hm-backup";

  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.shetty = {
    imports = [ ../../../home/shetty/laptop.nix ];

    # RTX 4070 Laptop = compute capability 8.9. CUDA is enabled for ollama
    # only (no global nixpkgs.config.cudaSupport), and without cudaArches
    # llama.cpp builds every arch the toolkit supports (sm_50…sm_121).
    services.ollama.package = pkgs.ollama-cuda.override { cudaArches = [ "sm_89" ]; };
  };

  # Desktop's cached runtimes inherit the host nix-ld library path.
  programs.nix-ld.libraries = lib.mkIf config.programs.nix-ld.enable (
    inputs.codex-desktop-linux.packages.${pkgs.stdenv.hostPlatform.system}.default.passthru.workspaceRuntimeLibraries
  );
}
