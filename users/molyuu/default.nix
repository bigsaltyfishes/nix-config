{ pkgs, system, ... }:
{
  users.users.molyuu = if (system == "x86_64-linux") then {
    isNormalUser = true;
    home = "/home/molyuu";
    password = "defaultpassword";
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "docker" "libvirtd" "storage" ];
    shell = pkgs.zsh;
  } else {
    home = "/Users/molyuu";
  };
}
