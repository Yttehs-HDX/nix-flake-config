{ lib, normalized }:
let
  checkRelation = relationId: relation:
    if !(builtins.hasAttr relation.user normalized.users) || !(builtins.hasAttr relation.host normalized.hosts) then
      true
    else
      let
        user = normalized.users.${relation.user};
        host = normalized.hosts.${relation.host};
      in
        if relation.enable && relation.activation.desktop.enable == true && !user.capabilities.desktop.enable then
          throw "Relation `${relationId}` cannot enable desktop because user `${relation.user}` does not declare desktop capability."
        else if relation.enable && relation.activation.desktop.enable == true && !host.capabilities.desktop.enable then
          throw "Relation `${relationId}` cannot enable desktop because host `${relation.host}` does not support desktop capability."
        else if relation.enable && relation.activation.development.enable == true && !user.capabilities.development.enable then
          throw "Relation `${relationId}` cannot enable development because user `${relation.user}` does not declare development capability."
        else if relation.enable && relation.activation.theme.enable == true && !user.capabilities.theme.enable then
          throw "Relation `${relationId}` cannot enable theme because user `${relation.user}` does not declare theme capability."
        else
          true;
in
lib.mapAttrsToList checkRelation normalized.relations
