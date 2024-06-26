{ ... }:
{
  imports = [
    ./udisks.nix
    ./gnome.nix
    ./pantheon.nix
  ];

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Blueman
  services.blueman.enable = true;
}