# ocr package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "ocr";

  metadata = presets.linuxDesktopUser "custom";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/ocr.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/ocr.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/ocr.nix;
      system = null;
    };
  };
}
