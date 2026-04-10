{ pipeline }:
let
  current = pipeline.current."Shetty@Shetty-Laptop";
  input = pipeline.projectionInputs."Shetty@Shetty-Laptop";
in assert current.effectiveCapabilities.desktop.enable;
assert input.identity.name == "shetty";
assert input.identity.homeDirectory == "/home/shetty";
assert input.account.initialHashedPassword
  == "$y$j9T$IbyB4U5AIUqcxol3JR60E0$/Wr3iDHuKpYBX7lkBSMJHGWlRS3quNv.DqQvkpKK4dD";
assert !(builtins.hasAttr "auth" input);
true
