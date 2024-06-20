{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: super: {
      pyzy = final.callPackage ./pyzy { };
      steam-im-modules = final.callPackage ./steam-im-modules { };
      clash-verge-service = final.callPackage ./clash-verge-service { };
      ibus-engines = super.ibus-engines // {
        pinyin = final.callPackage ./ibus-pinyin { };
        table-cangjie-lite = final.callPackage ./ibus-chinese-tables { inherit super; };
      };
      zinit = final.callPackage ./zinit { inherit super;};
    })

    inputs.rust-overlay.overlays.default
  ];
}