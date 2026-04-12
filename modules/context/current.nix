{ lib, instances }:
lib.mapAttrs (_: current:
  let
    effectiveCapabilities =
      import ./effective-capabilities.nix { inherit current; };
  in current // {
    inherit effectiveCapabilities;
    packages = import ./packages.nix {
      inherit lib;
      inherit current;
    };
    unsupportedPackages = import ./unsupported-packages.nix {
      inherit lib;
      inherit current;
    };
    theme = import ./theme.nix {
      inherit lib;
      inherit current;
    };
  }) instances
