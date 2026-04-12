# huggingface-hub package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "huggingface-hub";

  metadata = presets.crossPlatformUserPackage "package";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/huggingface-hub.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/huggingface-hub.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/huggingface-hub.nix;
      system = null;
    };
  };
}
