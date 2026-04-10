{ lib, instances }:
lib.mapAttrs (_: instance:
  let
    effectiveCapabilities =
      import ./effective-capabilities.nix { current = instance; };
    current = instance // { inherit effectiveCapabilities; };
  in current // {
    software = import ./software.nix {
      inherit lib;
      current = current;
    };
    theme = import ./theme.nix { current = current; };
  }) instances
