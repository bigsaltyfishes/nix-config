{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  config = {
    environment.systemPackages =
      (with inputs.nix-alien.packages.${pkgs.system}; [
        nix-alien
      ])
      ++ (with pkgs; [
        appimage-run
      ]);

    services.sshd.enable = true;
    services.resolved.enable = true;

    programs.nix-ld.enable = true;

    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    molyuu.system.binfmt = {
      enable = true;
      emulatedSystems = [ "aarch64-linux" ];
    };

    virtualisation.docker = {
      enable = true;
      storageDriver = lib.mkDefault "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    system.stateVersion = "unstable";
    networking.hostName = "molyuu";
  };
}
