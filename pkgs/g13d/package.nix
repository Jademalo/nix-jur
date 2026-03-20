{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation {
  pname = "g13d";
  version = "1.0.4-master-2025-03-23";

  src = fetchFromGitHub {
    owner = "khampf";
    repo = "g13";
    rev = "acea10b7ae7b673a0b41545c71084c9b9b63d1d7";
    hash = "sha256-RKqf9CsEEomffcgQj2PTZzWbotGDb21zckbXVUTfEp8=";
  };

  buildInputs = with pkgs; [
    log4cpp
    libevdev
    libusb1
    gtest
  ];

  nativeBuildInputs = with pkgs; [
    cmake
    makeWrapper
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp ./{g13d,pbm2lpbm} "$out/bin/"
    install -D "$src/91-g13.rules" "$out/lib/udev/rules.d/91-g13.rules"
    cp "$src/clock.sh" "$out/bin/g13-clock.sh"
    substituteInPlace $out/bin/g13-clock.sh --replace-fail './pbm2lpbm' 'pbm2lpbm'
    substituteInPlace $out/bin/g13-clock.sh --replace-fail 'convert' 'magick'
    wrapProgram $out/bin/g13-clock.sh --prefix PATH : "$out/bin:${
      pkgs.lib.makeBinPath [
        pkgs.bc
        pkgs.imagemagick
      ]
    }"
  '';

  meta = with pkgs.lib; {
    description = "Userspace driver for the Logitech G13";
    homepage = "https://github.com/khampf/g13";
    license = licenses.mit;
    maintainers = with maintainers; [ Jademalo ];
    platforms = platforms.linux;
    mainProgram = "g13d";
  };

}
