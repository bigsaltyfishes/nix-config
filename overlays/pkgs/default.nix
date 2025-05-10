{
  inputs,
  lib,
  system,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    inputs.nur.overlays.default
    inputs.rust-overlay.overlays.default
    (final: super: {
      rust-toolchains = super.rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; };
      qemu-user = final.callPackage ./qemu-user { };
      ttf-ms-win10 = final.callPackage ./ttf-ms-win10 { };
    })
  ];
}
