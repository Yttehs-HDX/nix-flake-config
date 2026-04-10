{ lib, normalized }:
lib.mapAttrsToList (relationId: relation:
  if !(builtins.hasAttr relation.user normalized.users) then
    throw "Relation `${relationId}` references missing user `${relation.user}`."
  else if !(builtins.hasAttr relation.host normalized.hosts) then
    throw "Relation `${relationId}` references missing host `${relation.host}`."
  else if relation.enable && !normalized.users.${relation.user}.enable then
    throw
    "Enabled relation `${relationId}` cannot target disabled user `${relation.user}`."
  else if relation.enable && !normalized.hosts.${relation.host}.enable then
    throw
    "Enabled relation `${relationId}` cannot target disabled host `${relation.host}`."
  else
    true) normalized.relations
