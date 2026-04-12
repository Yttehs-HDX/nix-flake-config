{ inputs, lib, projection }:
let
  nixosProjections =
    lib.filterAttrs (_: realization: realization.backend.type == "nixos")
    projection;

  nixosHosts = lib.foldl' (acc: realization:
    acc // {
      ${realization.hostId} = {
        system = realization.platformSystem;
        hardwareModules = realization.hostHardwareModules;
      };
    }) { } (lib.attrValues nixosProjections);

  foldHomeModules = projections:
    lib.foldl' (acc: projection:
      lib.foldl' (innerAcc: username:
        innerAcc // {
          ${username} = (innerAcc.${username} or [ ])
            ++ projection.homeModules.${username};
        }) acc (builtins.attrNames projection.homeModules)) { }
    (lib.attrValues projections);

  buildHost = hostId: host:
    let
      system = host.system;
      projections = lib.filterAttrs (_: realization:
        realization.backend.type == "nixos" && realization.hostId == hostId)
        projection;

      systemModules = lib.flatten
        (lib.mapAttrsToList (_: projection: projection.systemModules)
          projections);
      homeModules = foldHomeModules projections;

      homeManagerBridge = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users =
          lib.mapAttrs (_: modules: { imports = modules; }) homeModules;
      };
    in inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs hostId; };
      modules = [{ nixpkgs.config.allowUnfree = true; }] ++ host.hardwareModules
        ++ systemModules
        ++ [ inputs.home-manager.nixosModules.home-manager homeManagerBridge ];
    };
in lib.mapAttrs (hostId: host: buildHost hostId host) nixosHosts
