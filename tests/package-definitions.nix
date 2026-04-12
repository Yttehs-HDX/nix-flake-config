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
    let backendPath = def.backends.home-manager.home or null;
    in if backendPath == null then null else import backendPath)
    packageDefinitions;

  # Test: Package definitions are loaded correctly
  assertDefinitionsExist = assert builtins.hasAttr "git" packageDefinitions;
    assert builtins.hasAttr "hyprland" packageDefinitions;
    # hello is intentionally NOT migrated in Phase 1
    assert !(builtins.hasAttr "hello" packageDefinitions);
    true;

  # Test: Package definition structure is correct
  assertGitStructure = let git = packageDefinitions.git;
  in assert git.packageId == "git";
  assert builtins.hasAttr "metadata" git;
  assert builtins.hasAttr "backends" git;
  assert builtins.hasAttr "home-manager" git.backends;
  assert builtins.hasAttr "nixos" git.backends;
  assert builtins.hasAttr "nix-darwin" git.backends;
  true;

  # Test: Hyprland definition has correct metadata
  assertHyprlandMetadata = let hyprland = packageDefinitions.hyprland;
  in assert hyprland.packageId == "hyprland";
  assert hyprland.metadata.kind == "desktop-session";
  assert hyprland.metadata.owner == taxonomy.owners.user;
  assert builtins.elem taxonomy.targets.nixosHome
    hyprland.metadata.allowedTargets;
  assert hyprland.metadata.requiresDesktop == true;
  assert hyprland.backends.nix-darwin.home == null; # Not supported on Darwin
  true;

  # Test: Git definition is cross-platform
  assertGitCrossPlatform = let git = packageDefinitions.git;
  in assert builtins.elem taxonomy.targets.nixosHome
    git.metadata.allowedTargets;
  assert builtins.elem taxonomy.targets.darwinHome git.metadata.allowedTargets;
  assert builtins.elem taxonomy.targets.standaloneHomeManagerHome
    git.metadata.allowedTargets;
  true;

  # Test: Home catalog includes definition-based packages
  # Note: hello is still in home catalog but from legacy, not definition
  assertHomeCatalogDefinitions = assert builtins.hasAttr "git" homeCatalog;
    assert builtins.hasAttr "hyprland" homeCatalog;
    # Verify metadata is correct for definition-based packages
    assert homeCatalog.git.kind == "package";
    assert homeCatalog.hyprland.kind == "desktop-session";
    true;

  # Test: System catalog respects definition scope restrictions
  # hello remains in system catalog (from legacy cataloging)
  # git and hyprland should NOT be in system (user-only definitions)
  assertSystemCatalogDefinitions =
    assert builtins.hasAttr "hello" systemCatalog;
    # git is user-only, should NOT be in system catalog
    assert !(builtins.hasAttr "git" systemCatalog);
    # hyprland is user-only, should NOT be in system catalog
    assert !(builtins.hasAttr "hyprland" systemCatalog);
    true;

  # Test: Backend path references are correct
  assertBackendPaths = let git = packageDefinitions.git;
  in assert builtins.isPath git.backends.home-manager.home;
  assert builtins.isPath git.backends.nixos.home;
  assert builtins.isPath git.backends.nix-darwin.home;
  true;

  # Test: Registry derivation includes definition-based packages
  assertRegistryDerivation =
    assert builtins.hasAttr "git" testRegistryDerivation;
    assert builtins.hasAttr "hyprland" testRegistryDerivation;
    # Projectors should be callable
    assert builtins.isFunction testRegistryDerivation.git;
    # Verify hyprland projector is a function
    assert builtins.isFunction testRegistryDerivation.hyprland;
    true;

  # Run all tests
  allTests = [
    assertDefinitionsExist
    assertGitStructure
    assertHyprlandMetadata
    assertGitCrossPlatform
    assertHomeCatalogDefinitions
    assertSystemCatalogDefinitions
    assertBackendPaths
    assertRegistryDerivation
  ];
in builtins.deepSeq allTests true
