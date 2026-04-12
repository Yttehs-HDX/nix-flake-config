# vscode package definition
{ lib }:
let presets = import ../../packages/presets.nix;
in {
  packageId = "vscode";

  metadata = presets.crossPlatformUserPackage "gui";

  backends = {
    home-manager = {
      home = ../../projection/backends/home-manager/packages/vscode.nix;
      system = null;
    };
    nixos = {
      home = ../../projection/backends/home-manager/packages/vscode.nix;
      system = null;
    };
    nix-darwin = {
      home = ../../projection/backends/home-manager/packages/vscode.nix;
      system = null;
    };
  };
}
