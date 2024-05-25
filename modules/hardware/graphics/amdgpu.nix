{ config, pkgs, lib, ... }:
let
  cfg = config.molyuu.hardware.graphics;
in
{
  config = lib.mkIf cfg.amdgpu.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
}
