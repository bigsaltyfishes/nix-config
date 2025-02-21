{
  config,
  pkgs,
  system,
  ...
}:
let
  shell = config.molyuu.home-manager.profile.shell;
in
{
  users.users.molyuu = {
    isNormalUser = true;
    home = "/home/molyuu";
    password = "defaultpassword";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "docker"
      "libvirtd"
      "storage"
    ];
    shell =
      if (shell == "zsh") then
        pkgs.zsh
      else if (shell == "fish") then
        pkgs.fish
      else
        pkgs.bash;
  };
}
