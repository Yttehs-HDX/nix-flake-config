{ lib, pipeline }:
lib.mapAttrs (relationId: input:
  let
    backendProjection = if input.backend.type == "nixos" then
      import ./backends/nixos/default.nix { inherit input; }
    else if input.backend.type == "home-manager" then
      let
        homeProjection =
          import ./backends/home-manager/default.nix { inherit input; };
      in {
        systemModules = [ ];
        homeModule = homeProjection.homeModule;
        homeModules = {
          ${input.identity.name} = [ homeProjection.homeModule ];
        };
      }
    else if input.backend.type == "nix-darwin" then
      import ./backends/nix-darwin/default.nix { inherit input; }
    else
      throw "Unsupported backend `${input.backend.type}`.";
  in backendProjection // {
    inherit relationId;
    hostId = input.hostId;
    userId = input.userId;
    identityName = input.identity.name;
    backend = input.backend;
    scopes = input.scopes;
    platformSystem = input.current.host.platform.system;
    hostHardwareModules = input.current.host.hardware.modules or [ ];
  }) pipeline.projectionInputs
