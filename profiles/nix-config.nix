{ ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.substituters = [
    "https://cache.nixos.org/"
    "https://hyprland.cachix.org"
    "https://attic.xuyh0120.win/lantian"
  ];
  nix.settings.trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];
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
