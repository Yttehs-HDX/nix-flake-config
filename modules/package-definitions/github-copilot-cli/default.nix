# github-copilot-cli package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "github-copilot-cli";

  metadata = presets.crossPlatformUserPackage "integration-heavy";

  backends = {
    home-manager = {
      home = ./home.nix;
      system = null;
    };
    nixos = {
      home = ./home.nix;
      system = null;
    };
    nix-darwin = {
      home = ./home.nix;
      system = null;
    };
  };
}
