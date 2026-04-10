{ pipeline }:
let
  current = pipeline.current."Shetty@Shetty-Laptop";
  input = pipeline.projectionInputs."Shetty@Shetty-Laptop";
in assert current.effectiveCapabilities.desktop.enable;
assert current.effectiveCapabilities.theme.enable;
assert current.packages.home.kitty.enable;
assert current.packages.system.docker.enable;
assert input.identity.name == "shetty";
assert input.identity.homeDirectory == "/home/shetty";
assert input.account.initialHashedPassword
  == "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";
assert input.packages.home.kitty.settings.fontSize == 14.0;
assert input.packages.system.wireshark.settings.package == "qt";
assert input.theme.name == "catppuccin";
assert input.theme.palette.accentName == "lavender";
assert !(builtins.hasAttr "auth" input);
true
