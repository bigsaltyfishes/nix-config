{
  description = "Molyuu's Nix Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NUR
    nur.url = "github:nix-community/NUR";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # VSCode Extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Rust Toolchains
    rust-overlay.url = "github:oxalica/rust-overlay";

    # WSL
    NixOS-WSL.url = "github:nix-community/NixOS-WSL";
    NixOS-WSL.inputs.nixpkgs.follows = "nixpkgs";
    NixOS-WSL-VSCode.url = "github:K900/vscode-remote-workaround";
    NixOS-WSL-VSCode.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Steam Deck
    Jovian-NixOS.url = "github:bigsaltyfishes/Jovian-NixOS";
    Jovian-NixOS.inputs.nixpkgs.follows = "nixpkgs";

    # Spotify customization
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # CachyOS Kernel
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      NixOS-WSL,
      NixOS-WSL-VSCode,
      Jovian-NixOS,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      commonModules = [
        #niri.nixosModules.niri
        nur.modules.nixos.default
        ./users
        ./profiles
        ./modules/system
      ];
      linuxHomeManager = system: [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.molyuu = import ./users/molyuu/home;
          home-manager.backupFileExtension = "_bak";
          home-manager.extraSpecialArgs = { inherit inputs system; };
        }
      ];
    in
    {
      nixosConfigurations = {
        molyuu-desktop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules =
            commonModules
            ++ (linuxHomeManager system)
            ++ [
              ./machines/desktop/configuration.nix
            ];
        };

        molyuu-laptop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules =
            commonModules
            ++ (linuxHomeManager system)
            ++ [
              ./machines/f117-b6ck/configuration.nix
            ];
        };

        molyuu-steamdeck = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules =
            commonModules
            ++ (linuxHomeManager system)
            ++ [
              Jovian-NixOS.nixosModules.default
              ./machines/steamdeck/configuration.nix
            ];
        };

        molyuu-steamdeck-livecd = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules =
            commonModules
            ++ (linuxHomeManager system)
            ++ [
              Jovian-NixOS.nixosModules.default
              ./machines/steamdeck/livecd.nix
            ];
        };

        molyuu-wsl = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules =
            commonModules
            ++ (linuxHomeManager system)
            ++ [
              NixOS-WSL.nixosModules.wsl
              NixOS-WSL-VSCode.nixosModules.default
              ./machines/wsl/configuration.nix
            ];
        };

        molyuu-hyperv = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules =
            commonModules
            ++ (linuxHomeManager system)
            ++ [
              ./machines/hyperv/configuration.nix
            ];
        };
      };
    };
}
