###########################
#   TOP LEVEL - Nix flake
/*
{
  description = "Your new nix config";
  inputs = { ... };  <-- external dependencies
  outputs = { ... };
}
*/
{
  description = "Hyprland + Nixos";

  inputs = {
    # Stable Base + Unstable packages
    /*
    # The stable channel for NixOS packages (version 25.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # An optional unstable channel to grab cutting-edge packages when needed
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    */

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # unstable base
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # use the same nixpkgs version defined above
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    ...
  }: {
    # replace 'nixos'with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # hostname = nixpkgs.lib...
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ravenousbyte = import ./home-manager/home.nix;
            backupFileExtension = "backup"; # backingup without breaking
          };
        }
        stylix.nixosModules.stylix
      ];
    };
  };
}
