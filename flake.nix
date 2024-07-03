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
        nur.nixosModules.nur
        ./users
        ./profiles
        ./modules
        (import ./overlays)
      ];
      linuxHomeManager = system: [
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.molyuu = import ./users/molyuu/home;
          home-manager.extraSpecialArgs = { inherit inputs system; };
        }
      ];
      darwinHomeManager = system: [
        home-manager.darwinModules.home-manager
        {
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
