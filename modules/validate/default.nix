{ lib, normalized }:
let
  references = import ./references.nix { inherit lib normalized; };
  capabilities = import ./capabilities.nix { inherit lib normalized; };
  resolveIdentityName = relation:
    if relation.identity.name != null then
      relation.identity.name
    else
      lib.toLower relation.user;

  enabledRelations =
    lib.filterAttrs (_: relation: relation.enable) normalized.relations;
  relationPairs = map (relation: "${relation.user}@${relation.host}")
    (lib.attrValues enabledRelations);
  hostIdentityPairs =
    map (relation: "${relation.host}@${resolveIdentityName relation}")
    (lib.attrValues enabledRelations);

  relationIdChecks = lib.mapAttrsToList (relationId: relation:
    if relationId == "${relation.user}@${relation.host}" then
      true
    else
      throw
      "Relation `${relationId}` must match `${relation.user}@${relation.host}`.")
    normalized.relations;

  hostChecks = lib.mapAttrsToList (hostId: host:
    if !host.enable then
      true
    else if host.platform.system == null then
      throw "Enabled host `${hostId}` must declare `platform.system`."
    else if host.backend.type == "nixos" && host.system.stateVersion
    == null then
      throw "NixOS host `${hostId}` must declare `system.stateVersion`."
    else if host.backend.type == "nix-darwin" && host.system.stateVersion
    == null then
      throw "nix-darwin host `${hostId}` must declare `system.stateVersion`."
    else
      true) normalized.hosts;

  relationStateChecks = lib.mapAttrsToList (relationId: relation:
    let
      host = normalized.hosts.${relation.host};
      hasHomeScope = host.backend.type == "nixos" || host.backend.type
        == "home-manager" || host.backend.type == "nix-darwin";
    in if relation.enable && hasHomeScope && relation.state.home.stateVersion
    == null then
      throw
      "Relation `${relationId}` must declare `state.home.stateVersion` for home scope."
    else
      true) enabledRelations;

  uniquenessCheck =
    if lib.length relationPairs == lib.length (lib.unique relationPairs) then
      true
    else
      throw "Enabled relations must be unique by user@host pair.";

  hostIdentityUniquenessCheck = if lib.length hostIdentityPairs
  == lib.length (lib.unique hostIdentityPairs) then
    true
  else
    throw "Enabled relations must resolve to unique usernames per host.";

  indexes = {
    relationsByHost = lib.foldl' (acc: relation:
      acc // {
        ${relation.host} = (acc.${relation.host} or [ ])
          ++ [ relation.relationId ];
      }) { } (lib.attrValues enabledRelations);

    relationsByUser = lib.foldl' (acc: relation:
      acc // {
        ${relation.user} = (acc.${relation.user} or [ ])
          ++ [ relation.relationId ];
      }) { } (lib.attrValues enabledRelations);
  };
in builtins.deepSeq [
  references
  capabilities
  relationIdChecks
  hostChecks
  relationStateChecks
  uniquenessCheck
  hostIdentityUniquenessCheck
] { inherit indexes; }
