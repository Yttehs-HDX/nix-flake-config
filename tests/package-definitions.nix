# Tests for package definition system
{ lib }:
let
  packageDefinitions = import ../modules/package-definitions { inherit lib; };
  taxonomy = import ../modules/packages/taxonomy.nix;
  homeCatalog = import ../modules/packages/catalog/home.nix;
  systemCatalog = import ../modules/packages/catalog/system.nix;
  migratedCrossPlatformUserPackages = [
    "android-tools"
    "asciiquarium"
    "bat"
    "btop"
    "cava"
    "cbonsai"
    "cmatrix"
    "codex"
    "cryptsetup"
    "dig"
    "direnv"
    "duf"
    "eza"
    "fastfetch"
    "figlet"
    "file"
    "fzf"
    "gh"
    "git"
    "github-copilot-cli"
    "hexecute"
    "htop"
    "huggingface-hub"
    "jq"
    "kitty"
    "lazydocker"
    "lazygit"
    "lolcat"
    "mikusays"
    "net-tools"
    "nerd-fonts-jetbrains-mono"
    "nix-index"
    "nixfmt-classic"
    "nixvim"
    "nmap"
    "noto-fonts"
    "noto-fonts-cjk-sans"
    "noto-fonts-cjk-serif"
    "noto-fonts-emoji-blob-bin"
    "pipes-rs"
    "poppler-utils"
    "ripgrep"
    "scrcpy"
    "tesseract"
    "tgpt"
    "tldr"
    "tmux"
    "translate-shell"
    "unrar"
    "unzip"
    "vlc"
    "vscode"
    "wget"
    "xdg"
    "yazi"
    "zip"
    "zsh"
  ];
  migratedLinuxDesktopUserPackages = [
    "brightnessctl"
    "cliphist"
    "fcitx5"
    "grimblast"
    "hypridle"
    "hyprland"
    "hyprpicker"
    "hyprpolkitagent"
    "kdeconnect"
    "libnotify"
    "network-manager"
    "ocr"
    "playerctl"
    "pulseaudio"
    "rofi"
    "rofimoji"
    "seahorse"
    "swappy"
    "swaylock-effects"
    "swaync"
    "swww"
    "udisks2"
    "waybar"
    "wl-clipboard"
  ];
  migratedDarwinHintPackages = [
    "clash-verge-rev"
    "feishu"
    "google-chrome"
    "hmcl"
    "jetbrains-toolbox"
    "krita"
    "obs-studio"
    "onlyoffice"
    "osu-lazer-bin"
    "qq"
    "universal-android-debloater"
    "wechat"
  ];

  # Test backend registry derivation
  # Simulate what home-manager projection registry does
  testRegistryDerivation = builtins.mapAttrs (id: def:
    let backendPath = def.backends.home-manager.home or null;
    in if backendPath == null then null else import backendPath)
    packageDefinitions;

  # Test: Package definitions are loaded correctly
  assertDefinitionsExist = assert builtins.hasAttr "git" packageDefinitions;
    assert builtins.hasAttr "android-tools" packageDefinitions;
    assert builtins.hasAttr "asciiquarium" packageDefinitions;
    assert builtins.hasAttr "bat" packageDefinitions;
    assert builtins.hasAttr "codex" packageDefinitions;
    assert builtins.hasAttr "lazygit" packageDefinitions;
    assert builtins.hasAttr "vscode" packageDefinitions;
    assert builtins.hasAttr "blueman" packageDefinitions;
    assert builtins.hasAttr "waybar" packageDefinitions;
    assert builtins.hasAttr "qq" packageDefinitions;
    assert builtins.hasAttr "zsh" packageDefinitions;
    assert builtins.hasAttr "hyprland" packageDefinitions;
    # hello is intentionally NOT migrated in Phase 1
    assert !(builtins.hasAttr "hello" packageDefinitions);
    true;

  # Test: Migrated cross-platform user packages share consistent metadata
  assertMigratedCrossPlatformMetadata = assert builtins.all (packageId:
    let definition = packageDefinitions.${packageId};
    in definition.metadata.owner == taxonomy.owners.user
    && definition.metadata.allowedTargets == taxonomy.allHomeTargets
    && definition.metadata.missingStrategy
    == taxonomy.missingStrategies.notApplicable)
    migratedCrossPlatformUserPackages;
    true;

  # Test: Migrated linux desktop user packages share linux-desktop metadata
  assertMigratedLinuxDesktopMetadata = assert builtins.all (packageId:
    let definition = packageDefinitions.${packageId};
    in definition.metadata.owner == taxonomy.owners.user
    && definition.metadata.requiresDesktop == true
    && definition.metadata.missingStrategy == taxonomy.missingStrategies.skip)
    migratedLinuxDesktopUserPackages;
    true;

  # Test: Migrated darwin hint packages share hint-manual metadata
  assertMigratedDarwinHintMetadata = assert builtins.all (packageId:
    let definition = packageDefinitions.${packageId};
    in definition.metadata.owner == taxonomy.owners.user
    && definition.metadata.missingStrategy
    == taxonomy.missingStrategies.hintManual) migratedDarwinHintPackages;
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
    assert builtins.hasAttr "android-tools" homeCatalog;
    assert builtins.hasAttr "lazygit" homeCatalog;
    assert builtins.hasAttr "bat" homeCatalog;
    assert builtins.hasAttr "zsh" homeCatalog;
    assert builtins.hasAttr "hyprland" homeCatalog;
    # Verify metadata is correct for definition-based packages
    assert homeCatalog.git.kind == "package";
    assert homeCatalog.bat.kind == "package";
    assert homeCatalog.zsh.kind == "environment";
    assert homeCatalog.hyprland.kind == "desktop-session";
    true;

  # Test: System catalog respects definition scope restrictions
  # hello is home-only legacy support and no longer appears in system catalog
  # git and hyprland should NOT be in system (user-only definitions)
  assertSystemCatalogDefinitions =
    assert !(builtins.hasAttr "hello" systemCatalog);
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
    assert builtins.hasAttr "bat" testRegistryDerivation;
    assert builtins.hasAttr "git" testRegistryDerivation;
    assert builtins.hasAttr "zsh" testRegistryDerivation;
    assert builtins.hasAttr "hyprland" testRegistryDerivation;
    # Projectors should be callable
    assert builtins.isFunction testRegistryDerivation.bat;
    assert builtins.isFunction testRegistryDerivation.git;
    assert builtins.isFunction testRegistryDerivation.zsh;
    # Verify hyprland projector is a function
    assert builtins.isFunction testRegistryDerivation.hyprland;
    true;

  # Run all tests
  allTests = [
    assertDefinitionsExist
    assertMigratedCrossPlatformMetadata
    assertMigratedLinuxDesktopMetadata
    assertMigratedDarwinHintMetadata
    assertGitStructure
    assertHyprlandMetadata
    assertGitCrossPlatform
    assertHomeCatalogDefinitions
    assertSystemCatalogDefinitions
    assertBackendPaths
    assertRegistryDerivation
  ];
in builtins.deepSeq allTests true
