# Jade's Nix User Repository

This is a simple repository collecting various packages I've built outside of regular `nixpkgs`

## g13d
This is a module that allows control of a Logitech G13 gameboard. It starts `g13d` as a service which can be accessed by piping commands [as explained here](https://github.com/khampf/g13?tab=readme-ov-file#configuring--remote-control). This is a very barebones driver, and has no profile handling or associated logic included. 
This module also includes `g13xml2config`, which can be used to convert Logitech Gaming Software `.xml` config files into `.bind` files for use with the driver.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-jur = {
      url = "github:jademalo/nix-jur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-jur, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nix-jur.nixosModules.g13d

          #nixpkgs.overlays = [
            #nix-gaming-edge.overlays.default
          #];
          
          #environment.systemPackages = with pkgs; [
            #g13d
          #];
        
          services.g13d = {
            enable = true;
            clock.enable = true;
          };

      ];
    };
  };
}
```