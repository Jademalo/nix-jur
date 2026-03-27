# Jade's Nix User Repository

This is a simple personal flake collecting various packages I've built outside of regular `nixpkgs`. I make no guarantee that this is kept up to date, but I thought I would keep it public in case it comes in handy for someone else.

### Overlays
None at the moment

### Modules
- `g13d`
- `g13gui`

## g13d
This is a module from [khampf/g13](https://github.com/khampf/g13) that allows control of a Logitech G13 gameboard. It starts `g13d` as a service which can be accessed by piping commands [as explained here](https://github.com/khampf/g13?tab=readme-ov-file#configuring--remote-control). This is a very barebones driver, and has no profile handling or associated logic included. 

This module also includes `g13xml2config`, which can be used to convert Logitech Gaming Software `.xml` config files into `.bind` files for use with the driver.

## g13gui
This is a variant fork of the original `g13d` project from [jtgans/g13gui](https://github.com/jtgans/g13gui), which includes a GUI configuration tool. Even though they both are forks of the same project, the functionality differs to the above driver as it has been rewritten from scratch in Python.

## hdr-toggle
This is a simple HDR toggle script for KDE Plasma from [cryptomilk/hdr-toggle](https://codeberg.org/cryptomilk/hdr-toggle). It can also be used as a wrapper around other applications, such as steam games with `hdr-toggle %command%`

# Example config

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
        nix-jur.nixosModules.default
        #nix-jur.nixosModules.g13d
        #nix-jur.nixosModules.g13gui

          nixpkgs.overlays = [
            nix-jur.overlays.default
            #nix-jur.overlays.hdr-toggle
          ];
          
          #environment.systemPackages = with pkgs; [
            #hdr-toggle
          #];
        
          services.g13d = {
            enable = true;
            clock.enable = true;
          };
          #programs.g13gui.enable = true;

      ];
    };
  };
}
```