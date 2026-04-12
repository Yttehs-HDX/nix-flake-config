# wireshark package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "wireshark";

  metadata = presets.crossPlatformSystemHost "package";

  backends = {
    home-manager = {
      home = null;
      system = null;
    };
    nixos = {
      home = null;
      system = ../../projection/backends/nixos/packages/wireshark.nix;
    };
    nix-darwin = {
      home = null;
      system = ../../projection/backends/nix-darwin/packages/wireshark.nix;
    };
  };
}
