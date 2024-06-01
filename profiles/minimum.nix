{ inputs, pkgs, ... }:
{
  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
    nix.settings.auto-optimise-store = true;
    nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowBroken = true;

    environment.systemPackages = (with inputs.nix-alien.packages.${pkgs.system}; [
      nix-alien
    ]) ++ (with pkgs; [
      appimage-run
    ]);

    services.sshd.enable = true;

    programs.zsh.enable = true;
    programs.nix-ld.enable = true;

    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    system.stateVersion = "unstable";
    networking.hostName = "molyuu";
  };
}
