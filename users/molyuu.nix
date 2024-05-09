{ pkgs, ... }:
{
  users.users.molyuu = {
    isNormalUser = true;
    home = "/home/molyuu";
    password = "defaultpassword";
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };
}
