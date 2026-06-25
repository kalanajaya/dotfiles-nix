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

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";  # unstable base
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # use the same nixpkgs version defined above
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
  # A list of CPU architectures this configuration can support
  systems = [ 
    "aarch64-linux" 
    #"i686-linux"
    "x86_64-linux"
    #"aarch64-darwin"
    #"x86_64-darwin" 
    ];
  
  # A helper function to easily repeat configuration logic across all the architectures listed above
  forAllSystems = nixpkgs.lib.genAttrs systems;

  in {
     # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    # Imports any custom packages you write inside a local ./pkgs directory, building them for all supported system types.

    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    # Sets alejandra as the default code formatter. Running nix fmt in this directory will automatically clean up your Nix code syntax.
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    # Allows you to modify or extend the default nixpkgs collection (e.g., patching a package or pulling a specific app from the unstable channel).
    # overlays = import ./overlays {inherit inputs;};

    # Exports custom, reusable configuration modules located in your local subdirectories.
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    # nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    # homeManagerModules = import ./modules/home-manager;
    
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # replace 'nixos'with your hostname
      nixos = nixpkgs.lib.nixosSystem {  # hostname = nixpkgs.lib...
        specialArgs = {inherit inputs;};
        modules = [
          # > main nixos configuration file <
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # replace with your username@hostname
      "ravenousbyte@nixos" = home-manager.lib.homeManagerConfiguration {
        # Home-manager requires 'pkgs' instance
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # replace x86_64-linux with your architecture 
        extraSpecialArgs = {inherit inputs;};
        modules = [
          # > home-manager configuration file <
          ./home-manager/home.nix
        ];
      };
    };
  };
}
