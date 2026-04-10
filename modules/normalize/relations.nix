{ lib, profile }:
lib.mapAttrs (relationId: relation: relation // { inherit relationId; }) profile.relations
