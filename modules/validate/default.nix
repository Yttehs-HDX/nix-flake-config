{ lib, normalized }:
let
  references = import ./references.nix { inherit lib normalized; };
  capabilities = import ./capabilities.nix { inherit lib normalized; };
  hasSystemScope = backendType:
    backendType == "nixos" || backendType == "nix-darwin";
  hasHomeScope = backendType:
    backendType == "nixos" || backendType == "home-manager" || backendType
    == "nix-darwin";
  relationSystemOnlyFields = relation:
    (lib.optional (relation.identity.uid != null) "identity.uid")
    ++ (lib.optional (relation.membership.primaryGroup != null)
      "membership.primaryGroup")
    ++ (lib.optional (relation.membership.extraGroups != [ ])
      "membership.extraGroups");
  relationUnsupportedFields = host: relation:
    let
      backendType = host.backend.type;
      systemOnlyFields = if host.capabilities.system.enable then
        [ ]
      else
        relationSystemOnlyFields relation;
      darwinUnsupportedFields = (lib.optional (backendType == "nix-darwin"
        && relation.membership.primaryGroup != null) "membership.primaryGroup")
        ++ (lib.optional (backendType == "nix-darwin"
          && relation.membership.extraGroups != [ ]) "membership.extraGroups");
    in lib.unique (systemOnlyFields ++ darwinUnsupportedFields);
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
    let
      backendType = host.backend.type;
      stateVersion = host.system.stateVersion;
      expectedSystemScope = hasSystemScope backendType;
      expectedHomeScope = hasHomeScope backendType;
    in if !host.enable then
      true
    else if host.platform.system == null then
      throw "Enabled host `${hostId}` must declare `platform.system`."
    else if host.capabilities.system.enable != expectedSystemScope then
      throw
      "Host `${hostId}` must keep `capabilities.system.enable` consistent with backend `${backendType}`."
    else if host.capabilities.home.enable != expectedHomeScope then
      throw
      "Host `${hostId}` must keep `capabilities.home.enable` consistent with backend `${backendType}`."
    else if backendType == "nixos" && stateVersion == null then
      throw "NixOS host `${hostId}` must declare `system.stateVersion`."
    else if backendType == "nixos" && !(builtins.isString stateVersion) then
      throw
      "NixOS host `${hostId}` must declare `system.stateVersion` as a string."
    else if backendType == "nix-darwin" && stateVersion == null then
      throw "nix-darwin host `${hostId}` must declare `system.stateVersion`."
    else if backendType == "nix-darwin" && !(builtins.isInt stateVersion) then
      throw
      "nix-darwin host `${hostId}` must declare `system.stateVersion` as an integer."
    else if !(hasSystemScope backendType) && stateVersion != null then
      throw
      "Host `${hostId}` must not declare `system.stateVersion` without system scope."
    else
      true) normalized.hosts;

  relationStateChecks = lib.mapAttrsToList (relationId: relation:
    let host = normalized.hosts.${relation.host};
    in if relation.enable && host.capabilities.home.enable
    && relation.state.home.stateVersion == null then
      throw
      "Relation `${relationId}` must declare `state.home.stateVersion` for home scope."
    else
      true) enabledRelations;

  relationScopeChecks = lib.mapAttrsToList (relationId: relation:
    let
      host = normalized.hosts.${relation.host};
      unsupportedFields = relationUnsupportedFields host relation;
    in if relation.enable && unsupportedFields != [ ] then
      throw "Relation `${relationId}` must not declare `${
        lib.concatStringsSep "`, `" unsupportedFields
      }` for backend `${host.backend.type}`."
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
  relationScopeChecks
  uniquenessCheck
  hostIdentityUniquenessCheck
] { inherit indexes; }
