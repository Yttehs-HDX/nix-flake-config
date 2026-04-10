{ pipeline }:
let
  current = pipeline.current."Shetty@Shetty-Laptop";
  input = pipeline.projectionInputs."Shetty@Shetty-Laptop";
in assert current.effectiveCapabilities.desktop.enable;
assert current.effectiveCapabilities.theme.enable;
assert current.software.home.kitty.enable;
assert current.software.system.docker.enable;
assert input.identity.name == "shetty";
assert input.identity.homeDirectory == "/home/shetty";
assert input.account.initialHashedPassword
  == "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";
assert input.software.home.kitty.settings.fontSize == 14.0;
assert input.software.system.wireshark.settings.package == "qt";
assert input.theme.name == "catppuccin";
assert input.theme.palette.accentName == "lavender";
assert !(builtins.hasAttr "auth" input);
true
