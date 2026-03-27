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

        packages.${pkgs.stdenv.hostPlatform.system} = {
          hdr-toggle = pkgs.callPackage ./pkgs/hdr-toggle/package.nix {};                          # Adding the package to the flake's packages
        };

        overlays = {
          default = final: prev: {
            hdr-toggle = self.packages.${final.stdenv.hostPlatform.system}.hdr-toggle;
          };
          hdr-toggle = final: prev: {                                                              # Name of the overlay to be called
            hdr-toggle = self.packages.${final.stdenv.hostPlatform.system}.hdr-toggle;             # The package that gets used for that overlay
          };
        };


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
