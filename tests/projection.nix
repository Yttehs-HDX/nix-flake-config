{ projection }:
let
  relation = projection."Shetty@Shetty-Laptop";
in
assert builtins.length relation.systemModules == 2;
assert builtins.hasAttr "shetty" relation.homeModules;
true
