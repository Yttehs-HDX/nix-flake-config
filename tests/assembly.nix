{ nixosConfigurations, homeConfigurations }:
assert builtins.hasAttr "Shetty-Laptop" nixosConfigurations;
assert builtins.hasAttr "shetty@Shetty-Laptop" homeConfigurations;
true
