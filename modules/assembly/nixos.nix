{ inputs, lib, pipeline, projection }:
let
  nixosHosts =
    lib.filterAttrs (_: host: host.enable && host.backend.type == "nixos")
    pipeline.normalized.hosts;

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
      system = host.platform.system;
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
        home-manager.extraSpecialArgs = { inherit inputs pipeline; };
        home-manager.users =
          lib.mapAttrs (_: modules: { imports = modules; }) homeModules;
      };
    in inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pipeline hostId; };
      modules = [{ nixpkgs.config.allowUnfree = true; }]
        ++ (host.hardware.modules or [ ]) ++ systemModules
        ++ [ inputs.home-manager.nixosModules.home-manager homeManagerBridge ];
    };
in lib.mapAttrs buildHost nixosHosts
