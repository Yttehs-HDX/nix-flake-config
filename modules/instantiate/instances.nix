{ lib, normalized }:
let
  instantiateRelation = relationId: relation:
    let
      user = normalized.users.${relation.user};
      host = normalized.hosts.${relation.host};
      backend = import ./backend.nix { inherit host; };
      scopes = import ./scopes.nix { backendType = backend.type; };
    in {
      inherit relationId backend scopes user host relation;
      userId = relation.user;
      hostId = relation.host;
    };
in lib.mapAttrs instantiateRelation (lib.filterAttrs (_: relation:
  relation.enable && normalized.users.${relation.user}.enable
  && normalized.hosts.${relation.host}.enable) normalized.relations)
