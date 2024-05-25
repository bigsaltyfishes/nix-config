{ lib, ... }:
{
  options.molyuu.home-manager.profile.extraFeatures = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Select the system profile for Molyuu's NixOS. Options include 'full' for a complete system, 'baseDevel' for basic development components, 'extraDevel' for additional development components, and 'extraApps' for additional applications. Note that 'full' is mutually exclusive with all other options and is equivalent to selecting all other options.";
    example = [ "baseDevel" "extraDevel" "extraApps" ];
  };
}