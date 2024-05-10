{
  description = "Molyuu's Nix Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NUR
    nur.url = "github:nix-community/NUR";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # VSCode Extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Rust Toolchains
    rust-overlay.url = "github:oxalica/rust-overlay";

    # WSL
    NixOS-WSL.url = "github:nix-community/NixOS-WSL";
    NixOS-WSL.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , NixOS-WSL
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        molyuu-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [
            nur.nixosModules.nur

            ./profiles
            ./modules/hardware/graphics
            ./modules/hardware/kernel
            ./machines/f117-b6ck/configuration.nix

            (import ./overlays)

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;

              home-manager.users.molyuu = import ./users/home/molyuu.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };

        molyuu-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [
            nur.nixosModules.nur

            ./profiles
            ./machines/wsl/configuration.nix
            NixOS-WSL.nixosModules.wsl

            (import ./overlays)

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;

              home-manager.users.molyuu = import ./users/home/molyuu.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
      };
    };
}
