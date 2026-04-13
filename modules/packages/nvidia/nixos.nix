{ input, definition }:
{ lib, pkgs, ... }:
let
  nvidiaBusId = definition.settings.nvidiaBusId or null;
  intelBusId = definition.settings.intelBusId or null;
  enablePrime = nvidiaBusId != null && intelBusId != null;
in {
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    cudaSupport = true;
    allowUnfreePredicate = pkg:
      let name = lib.getName pkg;
      in lib.hasPrefix "cuda" name || lib.hasPrefix "nvidia" name;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;

    powerManagement = {
      enable = true;
      finegrained = enablePrime;
    };
  } // lib.optionalAttrs enablePrime {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
        offloadCmdMainProgram = "prime-run";
      };
      nvidiaBusId = nvidiaBusId;
      intelBusId = intelBusId;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
}
