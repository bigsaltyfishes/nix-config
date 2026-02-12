{ ... }:
{
  imports = [
    ./apps
    ./shells
    ./devel
    ./theme
    ../../overlays
  ];

  fonts.fontconfig.enable = true;
}
