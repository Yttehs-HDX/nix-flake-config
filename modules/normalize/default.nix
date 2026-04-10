{ lib, profile }:
{
  users = import ./users.nix { inherit lib profile; };
  hosts = import ./hosts.nix { inherit lib profile; };
  relations = import ./relations.nix { inherit lib profile; };
}
