{ pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      steam-im-modules = pkgs.stdenv.mkDerivation {
        pname = "steam-im-modules";
        version = "jupiter-20240131";

        src = pkgs.fetchFromGitHub {
          owner = "valve-project";
          repo = "steam-qt-keyboard-plugin";
          rev = "eab7d4c13bbe1372b7b28731b8209c12037e91af";
          sha256 = "L9rKEUxDT0fYrvnPIMJS5/wSq1W2KowreaxeXmcCq60=";
        };

        nativeBuildInputs = with pkgs; [
          extra-cmake-modules
          wrapGAppsHook3
          wrapGAppsHook4
          libsForQt5.wrapQtAppsHook
        ];

        buildInputs = with pkgs; [
          libsForQt5.qtbase
          gtk3
          gtk4
        ];

        cmakeBuildType = "RelWithDebInfo";

        meta = with lib; {
          description = "Steam Qt Keyboard Plug-in";
          homepage = "https://github.com/valve-project/steam-qt-keyboard-plugin";
          license = licenses.gpl3;
          platforms = platforms.linux;
        };
      };
    })
  ];
}
