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
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" "https://cache.nixos.org/" "https://jovian-nixos.cachix.org/" ];
  nix.settings.trusted-public-keys = [ "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo=" ];
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
