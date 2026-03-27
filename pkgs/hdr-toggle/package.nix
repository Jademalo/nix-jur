{
  pkgs,
  lib,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "hdr-toggle";
  version = "main-26-03-26";

  src = pkgs.fetchFromCodeberg {
    owner = "cryptomilk";
    repo = "hdr-toggle";
    rev = "e4a379c4cb5218f5d1aaa7eed4e61901b7792b9d";
    hash = "sha256-zE9MXq5iLs6TFzfz1r5+NO7Nve5Fb1mRY5eKBIj5nUA=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp "$src/hdr-toggle.sh" "$out/bin/hdr-toggle"
    chmod 755 "$out/bin/hdr-toggle"
    wrapProgram $out/bin/hdr-toggle \
      --prefix PATH : "$out/bin:${pkgs.lib.makeBinPath [ pkgs.kdePackages.libkscreen pkgs.libnotify ]}"
  '';

  meta = with pkgs.lib; {
    description = "Script to toggle HDR in KDE Plasma";
    homepage = "https://codeberg.org/cryptomilk/hdr-toggle";
    license = licenses.gpl2;
    maintainers = with maintainers; [ Jademalo ];
    platforms = platforms.linux;
    mainProgram = "hdr-toggle";
  };

}
