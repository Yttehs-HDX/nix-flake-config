# clash-verge-rev package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "clash-verge-rev";

  metadata = presets.darwinHintManual "integration-heavy";

  backends = {
    home-manager = {
      home =
        ../../projection/backends/home-manager/packages/clash-verge-rev.nix;
      system = null;
    };
    nixos = {
      home =
        ../../projection/backends/home-manager/packages/clash-verge-rev.nix;
      system = null;
    };
    nix-darwin = {
      home =
        ../../projection/backends/home-manager/packages/clash-verge-rev.nix;
      system = null;
    };
  };
}
