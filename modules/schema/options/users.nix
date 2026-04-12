{ lib, ... }:
let
  schema = import ../default.nix { inherit lib; };
  types = lib.types;
  fontSpecType = types.oneOf [
    types.str
    (types.submodule {
      options = {
        family = lib.mkOption { type = types.str; };
        size = lib.mkOption {
          type = types.nullOr types.int;
          default = null;
        };
      };
    })
  ];
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

    packages = lib.mkOption {
      type = types.attrsOf schema.packageItemType;
      default = { };
    };

    programs = lib.mkOption {
      type = types.attrsOf schema.packageItemType;
      default = { };
    };

    services = lib.mkOption {
      type = types.attrsOf schema.packageItemType;
      default = { };
    };

    theme = lib.mkOption {
      type = types.submodule {
        options = {
          name = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
          };

          accent = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
          };

          flavor = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
          };

          fonts = {
            sans = lib.mkOption {
              type = types.nullOr fontSpecType;
              default = null;
            };

            monospace = lib.mkOption {
              type = types.nullOr fontSpecType;
              default = null;
            };

            emoji = lib.mkOption {
              type = types.nullOr fontSpecType;
              default = null;
            };

            default = lib.mkOption {
              type = types.nullOr fontSpecType;
              default = null;
            };
          };
        };
      };
      default = { };
    };

    policy = lib.mkOption {
      type = types.attrs;
      default = { };
    };
  };
}
