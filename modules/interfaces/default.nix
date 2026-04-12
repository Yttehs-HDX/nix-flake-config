{ lib, profile }:
let
  # Stage 1: Normalize source declarations
  # Produces: { users, hosts, relations }
  # - Injects IDs (userId, hostId, relationId)
  # - Merges programs/services/packages into unified packages structure
  # - Normalizes package definitions to { packageId, enable, settings }
  normalized = import ../normalize/default.nix { inherit lib profile; };

  # Stage 2: Validate normalized model
  # Produces: { indexes = { relationsByHost, relationsByUser } }
  # - Validates user/host references in relations
  # - Validates capability activation constraints
  # - Validates package declarations per scope
  # - Validates host backend/platform/stateVersion consistency
  # - Validates relation scope fields
  # - Checks uniqueness of user@host pairs and host@identity pairs
  # All validation checks are evaluated via deepSeq before indexes are returned
  validation = import ../validate/default.nix { inherit lib normalized; };

  # Stage 3: Instantiate User-Host bindings
  # Produces: attrset of instances with structure:
  #   { relationId, userId, hostId, backend, scopes, user, host, relation }
  # - Combines User + Host + Relation into deployment instances
  # - Derives backend type from host.backend.type
  # - Derives available scopes from backend type
  # - Filters to only enabled relations with enabled users/hosts
  instances =
    import ../instantiate/default.nix { inherit lib normalized validation; };

  # Stage 4: Build context for projection
  # Produces: { current, projectionInputs }
  # - current: instances enriched with effectiveCapabilities, packages, unsupportedPackages, theme
  # - projectionInputs: projection-ready interface with identity, account, packages, theme, etc.
  # - Performs semantic enrichment including package filtering and theme resolution
  # Note: Context may include business logic (see docs/module-boundaries.md)
  context = import ../context/default.nix { inherit lib instances; };
in {
  inherit profile normalized validation instances;
  current = context.current;
  projectionInputs = context.projectionInputs;
}
