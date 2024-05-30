{ config, lib, pkgs, ... }:
let
  cfg = config.services.clash-verge;
  clash-verge-service = pkgs.rustPlatform.buildRustPackage rec {
    pname = "clash-verge-service";
    version = "6f98d625291b0f9c2c89a567042dfa312edf000c";

    src = pkgs.fetchFromGitHub {
      owner = "clash-verge-rev";
      repo = pname;
      rev = version;
      hash = "sha256-RlE7GzHMph2TweMVz74q4ZKraCDVUWW3Q9OOZz1XpLA=";
    };

    patches = [
      ./molyuu.patch
    ];

    nativeBuildInputs = with pkgs; [ gcc gnumake perl ];

    cargoBuildFlags = [ "--release" ];

    cargoLock.lockFile = ./Cargo.lock;

    meta = {
      description = "Clash Verge Service";
      homepage = "https://github.com/${src.owner}/${src.repo}";
      license = lib.licenses.gpl3;
      mainProgram = "clash-verge-service";
    };
  };
in
{
  options.services.clash-verge = {
    enable = lib.mkEnableOption "Clash Verge Service";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mihomo ];
    systemd.services.clash-verge-service = {
      description = "Clash Verge Service helps to launch Clash Core.";
      after = [ "network-online.target" "nftables.service" "iptables.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        "CUSTOM_MIHOMO_BINARY" = "${pkgs.mihomo}/bin/mihomo";
      };
      serviceConfig = {
        ExecStart = "${clash-verge-service}/bin/clash-verge-service";
        Restart = "always";
        RestartSec = "5";
        Type = "simple";
      };
    };
  };
}
