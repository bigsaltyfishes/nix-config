{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.molyuu.system.binfmt;
  qus = pkgs.qemu-user.overrideAttrs { arches = cfg.emulatedSystems; };
in {
  options.molyuu.system.binfmt = {
    enable = lib.mkEnableOption "Enable binfmt support for QEMU";
    emulatedSystems = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "List of architectures to enable binfmt support for";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.emulatedSystems = cfg.emulatedSystems;
    boot.binfmt.registrations = let
      attrs = sys: {
        interpreter = "${qus.passthru.binaryFor sys}";
        wrapInterpreterInShell = false;
        preserveArgvZero = true;
        matchCredentials = true;
        fixBinary = true;
      };
    in
      lib.genAttrs cfg.emulatedSystems attrs;
  };
}
