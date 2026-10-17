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

  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.shetty = import ../../../home/shetty/laptop.nix;

  # Desktop's cached runtimes inherit the host nix-ld library path.
  programs.nix-ld.libraries = lib.mkIf config.programs.nix-ld.enable (
    inputs.codex-desktop-linux.packages.${pkgs.stdenv.hostPlatform.system}.default.passthru.workspaceRuntimeLibraries
  );
}
