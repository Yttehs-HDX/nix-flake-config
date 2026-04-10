{ inputs, lib, pipeline }:
import ../assembly/nixos.nix { inherit inputs lib pipeline; }
