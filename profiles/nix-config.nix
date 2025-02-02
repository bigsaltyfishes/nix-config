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
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" "https://cache.nixos.org/" "https://hyprland.cachix.org" ];
  nix.settings.trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
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
