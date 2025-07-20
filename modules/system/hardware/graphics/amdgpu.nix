{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.molyuu.hardware.graphics;
in
{
  config = lib.mkIf (cfg.enable && cfg.amdgpu.enable) {
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
