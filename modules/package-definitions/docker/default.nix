# docker package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "docker";

  metadata = presets.crossPlatformSystemHost "package";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/docker.nix;
    };
    nix-darwin = {
      home = null;
      system = ../../projection/backends/nix-darwin/packages/docker.nix;
    };
  };
}
