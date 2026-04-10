{ lib }:
let
  declarations = import ../source/declarations/default.nix;
  evaluated = lib.evalModules {
    modules = [
      ../source/default.nix
      {
        config.profile = declarations;
      }
    ];
  };
in
  evaluated.config.profile
