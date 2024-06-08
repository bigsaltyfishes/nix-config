{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      ibus-engines = prev.ibus-engines // {
        pinyin = prev.ibus-engines.libpinyin.overrideAttrs (old: {
          pname = "ibus-pinyin";

          src = pkgs.fetchFromGitHub {
            owner = "ibus";
            repo = "ibus-pinyin";
            rev = "998992d095ea71e456e8c4847e014237f3621f0f";
            sha256 = "8nM/dEjkNhQNv6Ikv4xtRkS3mALDT6OYC1EAKn1zNtI=";
          };

          configureFlags = [ ];

          buildInputs = with pkgs; [
            ibus
            pyzy
            intltool
            lua
            glib
            sqlite
            (python3.withPackages (pypkgs: with pypkgs; [
              pygobject3
              (toPythonModule ibus)
            ]))
            gtk3
            db
            lua
            opencc
            libsoup_3
            json-glib
          ];

          version = "1.5.1";
        });
      };
    })
  ];
}
