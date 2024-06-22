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

    # Steam Deck
    Jovian-NixOS.url = "github:bigsaltyfishes/Jovian-NixOS";
    Jovian-NixOS.inputs.nixpkgs.follows = "nixpkgs";

    # Extra
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = { self, nixpkgs, nur, NixOS-WSL, Jovian-NixOS, home-manager, ... } @ inputs:
    let
      inherit (self) outputs;
      commonModules = [
        nur.nixosModules.nur
        ./users
        ./profiles
        ./modules
        (import ./overlays)
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.molyuu = import ./users/molyuu/home;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    in
    {
      nixosConfigurations = {
        molyuu-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = commonModules ++ [
            ./machines/f117-b6ck/configuration.nix
          ];
        };

        molyuu-steamdeck = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = commonModules ++ [
            Jovian-NixOS.nixosModules.default
            ./machines/steamdeck/configuration.nix
          ];
        };

        molyuu-steamdeck-livecd = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = commonModules ++ [
            Jovian-NixOS.nixosModules.default
            ./machines/steamdeck/livecd.nix
          ];
        };

        molyuu-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = commonModules ++ [
            ./machines/wsl/configuration.nix
            NixOS-WSL.nixosModules.wsl
          ];
        };
      };
    };
}
