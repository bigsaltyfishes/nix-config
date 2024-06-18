{ stdenv
, fetchFromGitHub
, autoreconfHook
, gettext
, pkg-config
, wrapGAppsHook3
, ibus
, pyzy
, intltool
, lua
, glib
, sqlite
, python3
, gtk3
, lib
}:
stdenv.mkDerivation {
  pname = "ibus-pinyin";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ibus";
    repo = "ibus-pinyin";
    rev = "998992d095ea71e456e8c4847e014237f3621f0f";
    sha256 = "8nM/dEjkNhQNv6Ikv4xtRkS3mALDT6OYC1EAKn1zNtI=";
  };

  strictDeps = true;

  configureFlags = [ ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    pkg-config
    python3
    sqlite
    wrapGAppsHook3
  ];

  buildInputs = [
    ibus
    pyzy
    lua
    glib
    sqlite
    gtk3
  ];

  meta = with lib; {
    isIbusEngine = true;
    description = "Pinyin (Chinese) input method for the IBus framework";
    homepage = "https://github.com/ibus/ibus-pinyin";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
