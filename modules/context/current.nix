{ lib, instances }:
lib.mapAttrs (_: instance:
  let
    effectiveCapabilities =
      import ./effective-capabilities.nix { current = instance; };
    current = instance // { inherit effectiveCapabilities; };
  in current // {
    packages = import ./packages.nix {
      inherit lib;
      current = current;
    };
    theme = import ./theme.nix {
      inherit lib;
      current = current;
    };
  }) instances
