# Tests for package definition system
{ lib }:
let
  packageDefinitions = import ../modules/package-definitions { inherit lib; };
  taxonomy = import ../modules/packages/taxonomy.nix;
  presets = import ../modules/packages/presets.nix;
  homeCatalog = import ../modules/packages/catalog/home.nix;
  systemCatalog = import ../modules/packages/catalog/system.nix;

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
    assert builtins.hasAttr "defaultSettings" git;
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

  # Test: Hyprland definition has default settings
  assertHyprlandSettings =
    let hyprland = packageDefinitions.hyprland;
    in
    assert hyprland.defaultSettings.xwaylandEnable == true;
    assert hyprland.defaultSettings.launcherCommand == "rofi -show drun";
    true;

  # Test: Hello definition supports all backends
  assertHelloBackends =
    let hello = packageDefinitions.hello;
    in
    assert hello.backends.home-manager.home != null;
    assert hello.backends.nixos.home != null;
    assert hello.backends.nix-darwin.home != null;
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
    true;

  # Test: System catalog derives from definitions
  assertSystemCatalogDerivation =
    assert builtins.hasAttr "hello" systemCatalog;
    # hello should be in system catalog since it has system targets
    assert systemCatalog.hello.kind == "package";
    true;

  # Test: Backend path references are correct
  assertBackendPaths =
    let git = packageDefinitions.git;
    in
    assert builtins.isPath git.backends.home-manager.home;
    assert builtins.isPath git.backends.nixos.home;
    assert builtins.isPath git.backends.nix-darwin.home;
    true;

  # Run all tests
  allTests = [
    assertDefinitionsExist
    assertGitStructure
    assertHyprlandMetadata
    assertHyprlandSettings
    assertHelloBackends
    assertGitCrossPlatform
    assertHomeCatalogDerivation
    assertSystemCatalogDerivation
    assertBackendPaths
  ];
in
builtins.deepSeq allTests true
