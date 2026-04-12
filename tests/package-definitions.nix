# Tests for package definition system
{ lib }:
let
  packageDefinitions = import ../modules/package-definitions { inherit lib; };
  taxonomy = import ../modules/packages/taxonomy.nix;
  presets = import ../modules/packages/presets.nix;
  homeCatalog = import ../modules/packages/catalog/home.nix;
  systemCatalog = import ../modules/packages/catalog/system.nix;

  # Test backend registry derivation
  # Simulate what home-manager projection registry does
  testRegistryDerivation = builtins.mapAttrs (id: def:
    let
      backendPath = def.backends.home-manager.home or null;
    in
    if backendPath == null then null else import backendPath
  ) packageDefinitions;

  # Test: Package definitions are loaded correctly
  assertDefinitionsExist =
    assert builtins.hasAttr "git" packageDefinitions;
    assert builtins.hasAttr "hello" packageDefinitions;
    assert builtins.hasAttr "hyprland" packageDefinitions;
    true;

  # Test: Package definition structure is correct
  assertGitStructure =
    let git = packageDefinitions.git;
    in
    assert git.packageId == "git";
    assert builtins.hasAttr "metadata" git;
    assert builtins.hasAttr "backends" git;
    assert builtins.hasAttr "home-manager" git.backends;
    assert builtins.hasAttr "nixos" git.backends;
    assert builtins.hasAttr "nix-darwin" git.backends;
    true;

  # Test: Hyprland definition has correct metadata
  assertHyprlandMetadata =
    let hyprland = packageDefinitions.hyprland;
    in
    assert hyprland.packageId == "hyprland";
    assert hyprland.metadata.kind == "desktop-session";
    assert hyprland.metadata.owner == taxonomy.owners.user;
    assert builtins.elem taxonomy.targets.nixosHome hyprland.metadata.allowedTargets;
    assert hyprland.metadata.requiresDesktop == true;
    assert hyprland.backends.nix-darwin.home == null;  # Not supported on Darwin
    true;

  # Test: Hello definition supports all backends
  assertHelloBackends =
    let hello = packageDefinitions.hello;
    in
    assert hello.backends.home-manager.home != null;
    assert hello.backends.nixos.home != null;
    assert hello.backends.nix-darwin.home != null;
    true;

  # Test: Hello is cross-scope (both home and system)
  assertHelloCrossScope =
    let hello = packageDefinitions.hello;
    in
    assert hello.packageId == "hello";
    assert hello.metadata.owner == taxonomy.owners.host;
    # Should support all targets (both home and system)
    assert builtins.elem taxonomy.targets.nixosHome hello.metadata.allowedTargets;
    assert builtins.elem taxonomy.targets.nixosSystem hello.metadata.allowedTargets;
    assert builtins.elem taxonomy.targets.darwinHome hello.metadata.allowedTargets;
    assert builtins.elem taxonomy.targets.darwinSystem hello.metadata.allowedTargets;
    true;

  # Test: Git definition is cross-platform
  assertGitCrossPlatform =
    let git = packageDefinitions.git;
    in
    assert builtins.elem taxonomy.targets.nixosHome git.metadata.allowedTargets;
    assert builtins.elem taxonomy.targets.darwinHome git.metadata.allowedTargets;
    assert builtins.elem taxonomy.targets.standaloneHomeManagerHome git.metadata.allowedTargets;
    true;

  # Test: Home catalog derives from definitions
  assertHomeCatalogDerivation =
    assert builtins.hasAttr "git" homeCatalog;
    assert builtins.hasAttr "hello" homeCatalog;
    assert builtins.hasAttr "hyprland" homeCatalog;
    # Verify metadata is correct (from definition, not legacy)
    assert homeCatalog.git.kind == "package";
    assert homeCatalog.hyprland.kind == "desktop-session";
    assert homeCatalog.hello.kind == "package";
    true;

  # Test: System catalog correctly includes cross-scope packages
  assertSystemCatalogInclusions =
    # hello is cross-scope (used in both user and host packages in tests)
    assert builtins.hasAttr "hello" systemCatalog;
    assert systemCatalog.hello.kind == "package";
    # git is user-only, should NOT be in system catalog
    assert !(builtins.hasAttr "git" systemCatalog);
    # hyprland is user-only, should NOT be in system catalog
    assert !(builtins.hasAttr "hyprland" systemCatalog);
    true;

  # Test: Backend path references are correct
  assertBackendPaths =
    let git = packageDefinitions.git;
    in
    assert builtins.isPath git.backends.home-manager.home;
    assert builtins.isPath git.backends.nixos.home;
    assert builtins.isPath git.backends.nix-darwin.home;
    true;

  # Test: Registry derivation produces callable projectors
  assertRegistryDerivation =
    # Verify that derived registry contains projectors for migrated packages
    assert builtins.hasAttr "git" testRegistryDerivation;
    assert builtins.hasAttr "hello" testRegistryDerivation;
    assert builtins.hasAttr "hyprland" testRegistryDerivation;
    # Verify git projector is a function (returns a function when called)
    assert builtins.isFunction testRegistryDerivation.git;
    # Verify hello projector is a function
    assert builtins.isFunction testRegistryDerivation.hello;
    # Verify hyprland projector is a function
    assert builtins.isFunction testRegistryDerivation.hyprland;
    true;

  # Run all tests
  allTests = [
    assertDefinitionsExist
    assertGitStructure
    assertHyprlandMetadata
    assertHelloBackends
    assertHelloCrossScope
    assertGitCrossPlatform
    assertHomeCatalogDerivation
    assertSystemCatalogInclusions
    assertBackendPaths
    assertRegistryDerivation
  ];
in
builtins.deepSeq allTests true
