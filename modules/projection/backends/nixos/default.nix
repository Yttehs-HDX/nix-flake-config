{ input }:
let homeProjection = import ../home-manager/default.nix { inherit input; };
in {
  systemModules = [
    (import ./system.nix { inherit input; })
    (import ./identity.nix { inherit input; })
  ] ++ (import ./user-packages/default.nix { inherit input; });

  homeModule = homeProjection.homeModule;
  homeModules = { ${input.identity.name} = [ homeProjection.homeModule ]; };
}
