{ pkgs, projection }:
let
  relation = projection."Shetty@Shetty-Laptop";
  systemModule = builtins.elemAt relation.systemModules 0;
  identityModule = builtins.elemAt relation.systemModules 1;
  systemConfig = systemModule {
    inherit pkgs;
    lib = pkgs.lib;
  };
  identityConfig = identityModule { lib = pkgs.lib; };
  homeConfig = relation.homeModule {
    inherit pkgs;
    lib = pkgs.lib;
  };
in assert builtins.length relation.systemModules == 2;
assert builtins.hasAttr "shetty" relation.homeModules;
assert builtins.length systemConfig.imports == 3;
assert builtins.length homeConfig.imports == 5;
assert homeConfig.programs.home-manager.enable;
assert !(systemConfig ? boot);
assert !(builtins.hasAttr "initialPassword" identityConfig.users.users.shetty);
assert identityConfig.users.users.shetty.initialHashedPassword
  == "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";
assert systemConfig.users.mutableUsers.content;
true
