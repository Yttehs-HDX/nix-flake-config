# github-copilot-cli package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "github-copilot-cli";

  metadata = presets.crossPlatformUserPackage "integration-heavy";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/github-copilot-cli.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/github-copilot-cli.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/github-copilot-cli.nix;
      system = null;
    };
  };
}
