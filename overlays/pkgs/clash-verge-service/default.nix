{ lib
, rustPlatform
, fetchFromGitHub
, gcc
, gnumake
, perl
, ...
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-verge-service";
  version = "6f98d625291b0f9c2c89a567042dfa312edf000c";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = pname;
    rev = version;
    hash = "sha256-RlE7GzHMph2TweMVz74q4ZKraCDVUWW3Q9OOZz1XpLA=";
  };

  nativeBuildInputs = [ gcc gnumake perl ];

  cargoBuildFlags = [ "--release" ];

  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = with lib; {
    description = "Clash Verge Service";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = licenses.gpl3;
    mainProgram = "clash-verge-service";
  };
}
