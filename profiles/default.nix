{ lib, ... }:
{
  options.molyuu.system.profile = {
    select = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Molyuu's NixOS system profiles";
    };
  };
}
