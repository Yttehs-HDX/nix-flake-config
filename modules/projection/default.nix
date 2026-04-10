{ lib, pkgs, context }:
lib.mapAttrs
  (_: input:
    if input.backend.type == "nixos" then
      import ./backends/nixos/default.nix { inherit pkgs input; }
    else if input.backend.type == "home-manager" then
      let
        homeProjection = import ./backends/home-manager/default.nix { inherit pkgs input; };
      in {
        systemModules = [ ];
        homeModules = {
          ${input.identity.name} = [ homeProjection.homeModule ];
        };
      }
    else
      throw "Unsupported backend `${input.backend.type}`.")
  context.projectionInputs
