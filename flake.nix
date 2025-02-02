{
  description = "Molyuu's Nix Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NUR
    nur.url = "github:nix-community/NUR";

    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

    # Steam Deck
    Jovian-NixOS.url = "github:bigsaltyfishes/Jovian-NixOS";
    Jovian-NixOS.inputs.nixpkgs.follows = "nixpkgs";

    # AGS
    ags.url = "github:Aylur/ags/v1";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    # Anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Icons
    more-waita = {
      url = "github:somepaulo/MoreWaita";
      flake = false;
    };
    
    # Extra
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , nix-darwin
    , NixOS-WSL
    , Jovian-NixOS
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      commonModules = [
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
      darwinHomeManager = system: [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.molyuu = import ./users/molyuu/home;
          home-manager.extraSpecialArgs = { inherit inputs system; };
        }
      ];
    in
    {
      darwinConfigurations = {
        molyuu-macbook = nix-darwin.lib.darwinSystem rec {
          system = "x86_64-darwin";
          specialArgs = { inherit inputs outputs system; };
          modules = commonModules ++ (darwinHomeManager system) ++ [
            ./machines/macbook/configuration.nix
          ];
        };
      };
      nixosConfigurations = {
        molyuu-desktop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules = commonModules ++ (linuxHomeManager system) ++ [
            ./machines/desktop/configuration.nix
          ];
        };

        molyuu-laptop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules = commonModules ++ (linuxHomeManager system) ++ [
            ./machines/f117-b6ck/configuration.nix
          ];
        };

        molyuu-steamdeck = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules = commonModules ++ (linuxHomeManager system) ++ [
            Jovian-NixOS.nixosModules.default
            ./machines/steamdeck/configuration.nix
          ];
        };

        molyuu-steamdeck-livecd = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules = commonModules ++ (linuxHomeManager system) ++ [
            Jovian-NixOS.nixosModules.default
            ./machines/steamdeck/livecd.nix
          ];
        };

        molyuu-wsl = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs system; };
          modules = commonModules ++ (linuxHomeManager system) ++ [
            NixOS-WSL.nixosModules.wsl
            ./machines/wsl/configuration.nix
          ];
        };
      };
    };
}
