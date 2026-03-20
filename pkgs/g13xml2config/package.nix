{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation {
  pname = "g13xml2config";
  version = "1.0.4-master-2025-03-23";

  src = fetchFromGitHub {
    owner = "khampf";
    repo = "g13";
    rev = "acea10b7ae7b673a0b41545c71084c9b9b63d1d7";
    hash = "sha256-RKqf9CsEEomffcgQj2PTZzWbotGDb21zckbXVUTfEp8=";
  };

  nativeBuildInputs = [
    pkgs.python3
  ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp g13xml2config $out/bin/g13xml2config
    chmod +x $out/bin/g13xml2config
    patchShebangs $out/bin/g13xml2config
  '';

  meta = with pkgs.lib; {
    description = "Logitech G13 XML configuration converter";
    homepage = "https://github.com/khampf/g13";
    license = licenses.mit;
    maintainers = with maintainers; [ Jademalo ];
    platforms = platforms.linux;
    mainProgram = "g13xml2config";
  };

}