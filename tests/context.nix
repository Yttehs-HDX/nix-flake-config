{ pipeline }:
let
  current = pipeline.current."Shetty@Shetty-Laptop";
  input = pipeline.projectionInputs."Shetty@Shetty-Laptop";
in assert current.effectiveCapabilities.desktop.enable;
assert input.identity.name == "shetty";
assert input.identity.homeDirectory == "/home/shetty";
assert !(builtins.hasAttr "auth" input);
true
