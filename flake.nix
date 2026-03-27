{
  description = "Jade's Nix user repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {

      /*
        packages.${pkgs.stdenv.hostPlatform.system} = {
           g13gui = pkgs.callPackage ./pkgs/g13gui/package.nix {};                          # Adding the package to the flake's packages
         };

         overlays = {
           g13gui = final: prev: {                                                          # Name of the overlay to be called
             g13gui = self.packages.${final.stdenv.hostPlatform.system}.g13gui;             # The package that gets used for that overlay
           };
         };
      */

      nixosModules = rec {
        g13d = import ./modules/g13d.nix; # Importing the module for the g13 service
        g13gui = import ./modules/g13gui.nix; # Importing the module for the g13gui tool with necessary udev rule
        default = { ... }: {
          imports = [ 
            g13d 
            g13gui 
          ];
        };
      };
    };

}
