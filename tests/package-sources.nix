{ lib, inputs, system }:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  unstablePkgs = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
  packageSources = import
    ../modules/projection/backends/home-manager/packages/package-sources.nix {
      inherit pkgs inputs;
    };
in assert packageSources.homeCustomSources.hexecute
  == inputs.hexecute.packages.${system}.default;
assert packageSources.homeCustomSources.mikusays
  == inputs.nur.legacyPackages.${system}.repos.zerozawa.mikusays;
assert packageSources.homeCustomSources.vscode == unstablePkgs.vscode;
assert packageSources.hasCustomSource "hexecute";
assert packageSources.hasCustomSource "mikusays";
assert packageSources.hasCustomSource "vscode";
assert !packageSources.hasCustomSource "wget";
assert !packageSources.hasCustomSource "ripgrep";
assert packageSources.getPackage "wget" == pkgs.wget;
assert packageSources.getPackage "ripgrep" == pkgs.ripgrep;
true
