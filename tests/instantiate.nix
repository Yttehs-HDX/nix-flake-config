{ pipeline }:
let instance = pipeline.instances."Shetty@Shetty-Laptop";
in assert instance.backend.type == "nixos";
assert instance.scopes.system;
assert instance.scopes.home;
true
