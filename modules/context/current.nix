{ lib, instances }:
lib.mapAttrs (_: instance:
  instance // {
    effectiveCapabilities =
      import ./effective-capabilities.nix { current = instance; };
  }) instances
