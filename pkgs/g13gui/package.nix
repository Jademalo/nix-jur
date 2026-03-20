{
  pkgs,
  lib,
  fetchFromGitHub, 
  makeDesktopItem 
}:

let

  pythonPackages = pkgs.python3Packages;

in

  pythonPackages.buildPythonApplication {
    pname = "g13gui";
    version = "0.1.0-master-2025-12-13";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "jtgans";
      repo = "g13gui";
      rev = "f0d85dfa7db1f5b700eacede970aa486d3b59863";
      hash = "sha256-xSQUR8DODnQBWr29YgDziJcwaVu+sm7aFDoYVoaM6x0=";
    };
    
    doCheck = false;

    nativeBuildInputs = with pkgs; [ 
      wrapGAppsHook3 
      gobject-introspection 
      appindicator-sharp
      copyDesktopItems
    ];

    buildInputs = with pkgs; [
      gtk3
      libappindicator
      gnome-desktop
    ];

    propagatedBuildInputs = with pythonPackages; [
      pillow
      pygobject3
      appdirs
      cffi
      dbus-python
      evdev
      psutil
      pyusb
    ];

    postInstall = ''
      mkdir -p "$out/${pythonPackages.python.sitePackages}/g13gui/bitwidgets/assets"
      cp -R "$src/g13gui/bitwidgets/assets" "$out/${pythonPackages.python.sitePackages}/g13gui/bitwidgets/"
      install -D "$src/etc/91-g13.rules" "$out/lib/udev/rules.d/91-g13.rules"
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "Logitech G13 GUI";
        exec = "g13gui";
        icon = "input-keyboard";
        desktopName = "Logitech G13 GUI";
        genericName = "A GUI configuration tool for the Logitech G13";
        categories = [ "Settings" ];
      })
    ];

    meta = with lib; {
      description = "Logitech G13 Configurator";
      homepage = "https://github.com/jtgans/g13gui";
      license = licenses.mit;
      maintainers = with maintainers; [ Jademalo ];
      platforms = platforms.linux;
      mainProgram = "g13gui";
    };

  }
