{
  inputs,
  lib,
  system,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.rust-overlay.overlays.default
    (final: super: {
      rust-toolchains = super.rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; };
      qemu-user = final.callPackage ./qemu-user { };
    })
  ];
}
