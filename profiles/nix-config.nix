{ lib, system, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  } // lib.optionalAttrs (system == "x86_64-linux") {
    dates = "weekly";
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };
}
