{ inputs, lib, pipeline, projection }:
let
  darwinHosts =
    lib.filterAttrs (_: host: host.enable && host.backend.type == "nix-darwin")
    pipeline.normalized.hosts;

  foldHomeModules = projections:
    lib.foldl' (acc: realization:
      lib.foldl' (innerAcc: username:
        innerAcc // {
          ${username} = (innerAcc.${username} or [ ])
            ++ realization.homeModules.${username};
        }) acc (builtins.attrNames realization.homeModules)) { }
    (lib.attrValues projections);

  buildHost = hostId: host:
    let
      system = host.platform.system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      projections = lib.filterAttrs (_: realization:
        realization.backend.type == "nix-darwin" && realization.hostId
        == hostId) projection;

      systemModules = lib.flatten
        (lib.mapAttrsToList (_: realization: realization.systemModules)
          projections);
      homeModules = foldHomeModules projections;

      homeManagerBridge = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit pipeline; };
        home-manager.users =
          lib.mapAttrs (_: modules: { imports = modules; }) homeModules;
      };
    in inputs.nix-darwin.lib.darwinSystem {
      inherit pkgs;
      inherit system;
      specialArgs = { inherit inputs pipeline hostId; };
      modules = (host.hardware.modules or [ ]) ++ systemModules
        ++ [ inputs.home-manager.darwinModules.home-manager homeManagerBridge ];
    };
in lib.mapAttrs buildHost darwinHosts
