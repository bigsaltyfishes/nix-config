{ config, lib, pkgs, ... }:
let
  cfg = config.molyuu.system.autoMount;
in
{
  options.molyuu.system.autoMount = {
    enable = lib.mkEnableOption "Auto mount block devices";
  };

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;
    systemd.user.services.auto-mount = {
      description = "Auto mount block devices";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart =
          let
            script = pkgs.writeShellScript "auto-mount" ''
              #!${pkgs.bash}/bin/bash

              pathtoname() {
                  ${pkgs.systemd}/bin/udevadm info -p /sys/"$1" | ${pkgs.gawk}/bin/awk -v FS== '/DEVNAME/ {print $2}'
              }

              # Remount all currently connected storage devices
              for dev in /dev/sd* /dev/mmcblk*; do
                  ${pkgs.udisks}/bin/udisksctl unmount --block-device "$dev" --no-user-interaction || true
                  ${pkgs.udisks}/bin/udisksctl mount --block-device "$dev" --no-user-interaction
              done

              # Monitor and mount new devices
              stdbuf -oL -- ${pkgs.systemd}/bin/udevadm monitor --udev -s block | while read -r -- _ _ event devpath _; do
                  if [ "$event" = add ]; then
                      devname=$(pathtoname "$devpath")
                      ${pkgs.udisks}/bin/udisksctl mount --block-device "$devname" --no-user-interaction
                  fi
              done
            '';
          in
          "${script}";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };
}
