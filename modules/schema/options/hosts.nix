{ lib, ... }:
let
  types = lib.types;
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

    backend.type = lib.mkOption {
      type = types.enum [ "home-manager" "nixos" "nix-darwin" ];
    };

    platform.system = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    capabilities = {
      system.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };

      home.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };

      desktop.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };

      userManagement.enable = lib.mkOption {
        type = types.bool;
        default = false;
      };
    };

    roles = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    system = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    hardware = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    networking = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    security = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    desktop = lib.mkOption {
      type = types.attrs;
      default = { };
    };

    packages.system = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    policy = lib.mkOption {
      type = types.attrs;
      default = { };
    };
  };
}
