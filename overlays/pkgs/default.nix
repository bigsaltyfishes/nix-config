{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: super: {
      clash-verge-service = final.callPackage ./clash-verge-service { };
      zinit = final.callPackage ./zinit { inherit super;};
    })

    inputs.rust-overlay.overlays.default
  ];
}