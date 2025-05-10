{ config, lib, ... }:
{
  options.molyuu.hardware.graphics = {
    nvidia = {
      enable = lib.mkEnableOption "Device have NVIDIA GPU";
      with_xdriver = lib.mkEnableOption "Install X Video Driver";
      package = lib.mkOption {
        type = lib.types.package;
        default = config.boot.kernelPackages.nvidiaPackages.stable;
        description = "NVIDIA driver to use";
      };
      offload = {
        enable = lib.mkEnableOption "Enable NVIDIA offload";
        intelBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:0:2:0";
          description = "Intel integrate gpu pci bus id";
        };
        nvidiaBusId = lib.mkOption {
          type = lib.types.str;
          default = "PCI:1:0:0";
          description = "NVIDIA GPU pci bud id";
        };
      };
    };

    intel = {
      enable = lib.mkEnableOption "Device have Intel GPU";
    };

    amdgpu = {
      enable = lib.mkEnableOption "Device have AMD GPU";
    };
  };

  config.hardware.graphics = lib.mkIf (config.molyuu.hardware.graphics.nvidia.enable || config.molyuu.hardware.graphics.intel.enable || config.molyuu.hardware.graphics.amdgpu.enable) {
    enable = true;
    enable32Bit = true;
  };

  imports = [
    ./intel.nix
    ./amdgpu.nix
    ./nvidia.nix
  ];
}
