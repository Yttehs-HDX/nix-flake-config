{ inputs, lib, pipeline }:
let
  homeScopeRelations = lib.filterAttrs (_: input: input.scopes.home) pipeline.projectionInputs;

  buildRelation = relationId: input:
    let
      system = input.current.host.platform.system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      homeProjection = import ../projection/backends/home-manager/default.nix { inherit pkgs input; };
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs pipeline relationId;
        };
        modules = [ homeProjection.homeModule ];
      };
in
lib.mapAttrs'
  (relationId: input:
    lib.nameValuePair "${input.identity.name}@${input.hostId}" (buildRelation relationId input))
  homeScopeRelations
