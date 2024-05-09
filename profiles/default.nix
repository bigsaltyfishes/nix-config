{ config, lib, ... }:
let 
  cfg = config.molyuu.system.profile;
in 
{
  options.molyuu.system.profile = {
    select = lib.mkOption  {
      type = lib.types.str;
      default = "";
      description = "Molyuu's NixOS system profiles";
    };
  };
}