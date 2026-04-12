{ lib, ... }:
let types = lib.types;
in {
  options = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    settings = lib.mkOption {
      type = types.attrs;
      default = { };
    };
  };
}
