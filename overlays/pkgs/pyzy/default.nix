{ stdenv
, fetchFromGitHub
, fetchurl
, autoreconfHook
, pkg-config
, wrapGAppsHook3
, sqlite
, python3
, ibus
, glib
, util-linux
, doxygen
, lib
}:
stdenv.mkDerivation {
  pname = "pyzy";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "pyzy";
    rev = "80b72cbec3981296666351f2e3a813965e0ad61c";
    sha256 = "bVzwMJP6iSrZRO4VA/nTC6eXU9WkGQ+1nQKhXSg0JEY=";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/openSUSE/pyzy/pull/1.patch";
      sha256 = "0xi2pz13sx65bhrpkbvprvn3mds5i9mwp990jb76y4bcmsrx5n04";
    })
    (fetchurl {
      url = "https://github.com/openSUSE/pyzy/pull/2.patch";
      sha256 = "1qh78a738nzkmq7dzqnaidpizg5xx3zn7q1nh42r9f9gvmc3zggh";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
    sqlite
    python3
  ];

  buildInputs = [
    ibus
    glib
    sqlite
    util-linux
    doxygen
  ];

  postPatch = ''
    patchShebangs .
  '';

  postConfigure = ''
    sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool
  '';

  meta = with lib; {
    description = "The Chinese PinYin and Bopomofo conversion library";
    homepage = "https://github.com/openSUSE/pyzy";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
