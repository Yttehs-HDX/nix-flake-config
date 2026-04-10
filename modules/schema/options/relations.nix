{ lib, ... }:
let types = lib.types;
in {
  options = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    user = lib.mkOption { type = types.str; };

    host = lib.mkOption { type = types.str; };

    identity = {
      name = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      uid = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
      };

      homeDirectory = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    membership = {
      primaryGroup = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      extraGroups = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };

    activation = {
      desktop.enable = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      development.enable = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      theme.enable = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
    };

    state.home.stateVersion = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    policy = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    overrides = lib.mkOption {
      type = types.attrs;
      default = { };
    };
  };
}
