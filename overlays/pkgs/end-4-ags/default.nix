{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "end-4-ags";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "5c396d7548cf1f6d2460e5b1425301d0c960fc50";
    sha256 = "sha256-EMhcIApxaV7X2H88eNWekKDpd56OU7CeWImftlkoM8o=";
  };

  patches = [ 
    ./0001-Use-system-python-environment.patch
    ./0002-Kill-session-instead-of-kill-Hyprland.patch
  ];
  
  buildPhase = ''
    mkdir -p $out
    cp -r .config/ags $out/
  '';

  meta = {
    description = "An AGS bar for Hyprland written by end-4";
    license = "GPL-3.0";
  };
}
