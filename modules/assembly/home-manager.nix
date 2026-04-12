{ inputs, lib, projection }:
let
  homeScopeRelations =
    lib.filterAttrs (_: realization: realization.homeModule != null) projection;

  buildRelation = relationId: realization:
    let
      system = realization.platformSystem;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs relationId; };
      modules = [ realization.homeModule ];
    };
in lib.mapAttrs' (relationId: realization:
  lib.nameValuePair "${realization.identityName}@${realization.hostId}"
  (buildRelation relationId realization)) homeScopeRelations
