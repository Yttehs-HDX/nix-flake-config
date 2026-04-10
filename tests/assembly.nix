{ nixosConfigurations, darwinConfigurations, homeConfigurations }:
assert builtins.hasAttr "Shetty-Laptop" nixosConfigurations;
assert darwinConfigurations == { };
assert builtins.hasAttr "shetty@Shetty-Laptop" homeConfigurations;
true
