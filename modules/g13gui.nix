{ config, pkgs, lib, ... }:

{

  options.programs.g13gui = {
    enable = lib.mkEnableOption "Logitech G13 GUI";
  };

  config = lib.mkIf config.programs.g13gui.enable {

    nixpkgs.overlays = [
      # Load derivation and add the package to nixpkgs
      (final: prev: {
        g13gui = prev.callPackage ./../pkgs/g13gui/package.nix {};
      })
    ];

    services.udev.packages = with pkgs; [
      g13gui
    ];

    environment.systemPackages = with pkgs; [
      g13gui
    ];

  };

}