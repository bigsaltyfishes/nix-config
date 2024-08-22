{ inputs, lib, system, ... }:
{
  nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
    (final: super: {
      clash-verge-service = final.callPackage ./clash-verge-service { };
      zinit = final.callPackage ./zinit { inherit super;};
      rust-toolchains = super.rust-bin.stable.latest.default.override {  extensions = [ "rust-src" ];  };
      qemu-user = final.callPackage ./qemu-user { };
    } // lib.optionalAttrs (system == "x86_64-darwin") {
      p11-kit = final.callPackage ./p11-kit { inherit super; };
    })
  ];
}