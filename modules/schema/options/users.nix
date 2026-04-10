{ lib, ... }:
let types = lib.types;
in {
  options = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };

    meta = {
      displayName = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      description = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      tags = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };

    preferences = {
      shell = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      editor = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      terminal = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    initialHashedPassword = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    capabilities = {
      desktop.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };

      development.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };

      theme.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };
    };

    packages.common = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    programs = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    services = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    theme = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    policy = lib.mkOption {
      type = types.attrs;
      default = { };
    };
  };
}
