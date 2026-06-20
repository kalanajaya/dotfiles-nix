{
  description = "System and Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # For your system-wide NixOS configuration
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix

        # This replaces the legacy <home-manager/nixos> import cleanly:
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # Inline your home.nix config or import it directly here
          home-manager.users.ravenousbyte = import ./home-manager/home.nix;
        }
      ];
    };
  };
}
