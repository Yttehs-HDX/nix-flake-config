{ lib, input }: [
  (import ./theme-toolkits.nix { inherit input; })
  (import ./session-wiring.nix { inherit input; })
]
