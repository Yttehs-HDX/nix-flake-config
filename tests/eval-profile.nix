{ lib, inputs, declarations }:
let
  evaluated = lib.evalModules {
    modules =
      [ ../modules/source/default.nix { config.profile = declarations; } ];
  };
  profile = evaluated.config.profile;
  pipeline = import ../modules/interfaces/default.nix { inherit lib profile; };
  projection =
    import ../modules/projection/default.nix { inherit lib pipeline; };
  assembly =
    import ../modules/assembly/default.nix { inherit inputs lib projection; };
in { inherit profile pipeline projection assembly; }
