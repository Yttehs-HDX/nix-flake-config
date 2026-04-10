{ pkgs, input }:
let
  homeProjection = import ../home-manager/default.nix { inherit pkgs input; };
in {
  systemModules = [
    (import ./system.nix { inherit pkgs input; })
    (import ./identity.nix { inherit input; })
  ];

  homeModules = {
    ${input.identity.name} = [ homeProjection.homeModule ];
  };
}
