{
  config,
  pkgs,
  lib,
  ...
}:

{

  options.services.g13d = {
    enable = lib.mkEnableOption "Logitech G13 daemon";
    clock.enable = lib.mkEnableOption "Logitech G13 clock widget";
  };

  config = lib.mkIf config.services.g13d.enable {

    nixpkgs.overlays = [
      # Load derivation and add the package to nixpkgs
      (final: prev: {
        g13d = prev.callPackage ./../pkgs/g13d/package.nix { };
        g13xml2config = prev.callPackage ./../pkgs/g13xml2config/package.nix { };
      })
    ];

    # Service for g13d
    systemd.services.g13d = {
      description = "Logitech G13 daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = pkgs.lib.getExe pkgs.g13d;
        ExecStartPost = "${pkgs.lib.getExe' pkgs.coreutils "sleep"} 2";
      };
      wantedBy = [ "multi-user.target" ];
    };

    # Service for clock widget
    systemd.services.g13-clock = lib.mkIf config.services.g13d.clock.enable {
      description = "Logitech G13 clock";
      after = [ "g13d.service" ];
      partOf = [ "g13d.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = pkgs.lib.getExe' pkgs.g13d "g13-clock.sh";
      };
      wantedBy = [ "multi-user.target" ];
    };

    fonts.packages = [ pkgs.corefonts ];

    environment.systemPackages = with pkgs; [
      g13xml2config
    ];

  };

}
