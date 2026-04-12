{ lib, instances }:
lib.mapAttrs (_: current:
  let
    effectiveCapabilities =
      import ./effective-capabilities.nix { inherit current; };
    current' = current // { inherit effectiveCapabilities; };
  in current' // {
    packages = import ./packages.nix {
      inherit lib;
      current = current';
    };
    unsupportedPackages = import ./unsupported-packages.nix {
      inherit lib;
      current = current';
    };
    theme = import ./theme.nix {
      inherit lib;
      current = current';
    };
  }) instances
