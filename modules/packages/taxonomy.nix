# Package classification taxonomy.
#
# Defines the coordinate system for host kinds, deployment targets,
# ownership, and missing-package strategies.
#
# This file is pure data — no function arguments, no lib dependency.
{
  # --- Host kinds ---
  # Each value identifies a class of host backend.
  hostKinds = {
    nixos = "nixos";
    darwin = "darwin";
    standaloneHomeManager = "standaloneHomeManager";
  };

  allHostKinds = [ "nixos" "darwin" "standaloneHomeManager" ];

  # --- Deployment targets (hostKind × scope) ---
  # A target encodes both the host kind and the deployment scope.
  targets = {
    nixosHome = "nixosHome";
    nixosSystem = "nixosSystem";
    darwinHome = "darwinHome";
    darwinSystem = "darwinSystem";
    standaloneHomeManagerHome = "standaloneHomeManagerHome";
    standaloneHomeManagerSystem = "standaloneHomeManagerSystem";
  };

  allTargets = [
    "nixosHome"
    "nixosSystem"
    "darwinHome"
    "darwinSystem"
    "standaloneHomeManagerHome"
    "standaloneHomeManagerSystem"
  ];

  allHomeTargets = [ "nixosHome" "darwinHome" "standaloneHomeManagerHome" ];

  allSystemTargets =
    [ "nixosSystem" "darwinSystem" "standaloneHomeManagerSystem" ];

  # --- Ownership ---
  owners = {
    user = "user";
    host = "host";
  };

  # Classifies how consumers should treat a package that is declared
  # but not supported on the current target. This taxonomy is metadata
  # only; actual reporting/enforcement is implemented by backend modules.
  missingStrategies = {
    notApplicable = "notApplicable"; # package is always available
    error =
      "error"; # unsupported package is reported by consumers; does not itself force evaluation failure
    skip = "skip"; # silently excluded
    hintManual = "hintManual"; # excluded with manual-install hint
  };

  # --- Backend type → host kind mapping ---
  backendToHostKind = {
    nixos = "nixos";
    "nix-darwin" = "darwin";
    "home-manager" = "standaloneHomeManager";
  };

  # --- Resolve deployment target from backend type and scope ---
  resolveTarget = backend: scope:
    let
      mapping = {
        nixos = {
          home = "nixosHome";
          system = "nixosSystem";
        };
        "nix-darwin" = {
          home = "darwinHome";
          system = "darwinSystem";
        };
        "home-manager" = {
          home = "standaloneHomeManagerHome";
          system = "standaloneHomeManagerSystem";
        };
      };
    in if builtins.hasAttr backend mapping
    && builtins.hasAttr scope mapping.${backend} then
      mapping.${backend}.${scope}
    else
      throw "Unknown backend/scope combination: ${backend}/${scope}";

  # --- Host kind → home target ---
  hostKindToHomeTarget = {
    nixos = "nixosHome";
    darwin = "darwinHome";
    standaloneHomeManager = "standaloneHomeManagerHome";
  };

  # --- Host kind → system target ---
  hostKindToSystemTarget = {
    nixos = "nixosSystem";
    darwin = "darwinSystem";
    standaloneHomeManager = "standaloneHomeManagerSystem";
  };
}
