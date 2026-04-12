# codex package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "codex";

  metadata = presets.crossPlatformUserPackage "integration-heavy";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/codex.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/codex.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/codex.nix;
      system = null;
    };
  };
}
