{ ... }:
{
  imports = [
    ./gnome.nix
    ./pantheon.nix
  ];

  # Flatpak
  services.flatpak.enable = true;

  # Blueman
  services.blueman.enable = true;
}