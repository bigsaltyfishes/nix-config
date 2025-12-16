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
      ttf-ms-win10 = final.callPackage ./ttf-ms-win10 { };
      cosmic-notifications = final.writeShellScriptBin "cosmic-notifications" ''
        LANG=en_US.UTF-8 ${super.cosmic-notifications}/bin/cosmic-notifications
      '';
      dxgkrnl-dkms = final.callPackage ./dxgkrnl-dkms { };
    })
  ];
}
