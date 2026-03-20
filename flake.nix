{
  description = "Jade's Nix user repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
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

/*  packages.${pkgs.stdenv.hostPlatform.system} = {
      g13d = pkgs.callPackage ./pkgs/g13d/package.nix {};                             # Adding the package to the flake's packages
    };

    overlays = {
      g13d = final: prev: {                                                           # Name of the overlay to be called
        g13d = self.packages.${final.stdenv.hostPlatform.system}.g13d;                # The package that gets used for that overlay
      };
    }; */

    nixosModules = {
      g13d = import ./modules/g13d.nix;                                                # Importing the module for the g13 service
    };
  };

}