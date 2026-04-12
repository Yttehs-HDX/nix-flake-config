# hmcl package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "hmcl";

  metadata = presets.darwinHintManual "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/hmcl.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/hmcl.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/hmcl.nix;
      system = null;
    };
  };
}
