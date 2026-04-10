{ inputs, lib, pipeline, projection }:
import ../assembly/nixos.nix { inherit inputs lib pipeline projection; }
