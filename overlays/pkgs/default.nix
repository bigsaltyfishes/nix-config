{ inputs, lib, system, ... }:
{
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.rust-overlay.overlays.default
    (final: super: {
      rust-toolchains = super.rust-bin.stable.latest.default.override {  extensions = [ "rust-src" ];  };
      qemu-user = final.callPackage ./qemu-user { };
      end-4-ags = final.callPackage ./end-4-ags { };
      end-4-hyprland-shaders = final.callPackage ./end-4-hyprland-shaders { };
      end-4-kvantum = final.callPackage ./end-4-kvantum { };
      illogical-impulse-oneui4-icons = final.callPackage ./illogical-impulse-oneui4-icons { };
    } // lib.optionalAttrs (system == "x86_64-darwin") {
      p11-kit = final.callPackage ./p11-kit { inherit super; };
    })
  ];
}
