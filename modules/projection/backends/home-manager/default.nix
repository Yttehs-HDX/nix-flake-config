{ pkgs, input }:
{
  homeModule = import ./home.nix { inherit pkgs input; };
}
