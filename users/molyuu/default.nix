{ pkgs, ... }:
{
  users.users.molyuu = {
    isNormalUser = true;
    home = "/home/molyuu";
    password = "defaultpassword";
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "docker" "libvirtd" "storage" ];
    shell = pkgs.zsh;
  };
}
