# Package diagnostics.
#
# Produces structured unsupported-package information including
# reason, suggestion, and missing strategy.
{ lib }:
let
  taxonomy = import ./taxonomy.nix;
  rules = import ./rules.nix { inherit lib; };

  unsupportedInfoFor = scope: current: packageId:
    let
      metadata = rules.metadataFor scope packageId;
      currentBackend = rules.resolveBackendType current;
      hostKind = if currentBackend != null then
        taxonomy.backendToHostKind.${currentBackend} or null
      else
        null;
      target = if currentBackend != null then
        taxonomy.resolveTarget currentBackend scope
      else
        null;
      platformLabel = rules.resolvePlatformLabel current;

      unsupportedHostKind = hostKind != null
        && !(builtins.elem hostKind (metadata.allowedHostKinds or [ ]));
      unsupportedTarget = target != null
        && !(builtins.elem target (metadata.allowedTargets or [ ]));
    in if !(unsupportedHostKind || unsupportedTarget) then
      null
    else {
      name = packageId;
      inherit scope;
      backend = currentBackend;
      platform = platformLabel;
      strategy = metadata.missingStrategy or taxonomy.missingStrategies.skip;
      reason = metadata.unsupportedReason or (if unsupportedTarget then
        "This package is not implemented on this backend."
      else
        "This package is only supported on ${
          builtins.concatStringsSep ", " (metadata.allowedHostKinds or [ ])
        } hosts.");
      suggestion = metadata.unsupportedSuggestion or (if unsupportedTarget then
        "Use a supported backend for automatic installation, or install it manually if available."
      else
        "Use a supported host type for automatic installation, or install it manually on this platform.");
    };

in { inherit unsupportedInfoFor; }
