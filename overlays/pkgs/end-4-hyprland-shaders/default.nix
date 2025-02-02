{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "end-4-hyprland-shaders";
  version = "latest";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "dots-hyprland";
    rev = "31985018ec269e9f4d12f91e486dd5dcd61fd022";
    sha256 = "sha256-cfR7UMF5XhOxEnfpQQdLIW8rmLLkMEbhXNiabaBXngI=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/.config/hypr/shaders $out/
  '';

  meta = {
    description = "Hyprland Shaders written by end-4";
    license = "GPL-3.0";
  };
}
