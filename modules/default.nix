{ lib, system, ... }:
{
  imports = lib.optionals (system == "x86_64-linux") [
    ./programs
    ./network
    ./locale
    ./desktop
    ./security
    ./services
    ./hardware
  ];
}