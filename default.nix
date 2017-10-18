with (import <nixpkgs> {});
let
  EQL5 = import ./EQL5.nix;
in
stdenv.mkDerivation rec {
  name = "iannix-${version}";
  version = "jhnn";
  src = ./.; # fetchFromGitHub {
  #   owner = "iannix";
  #   repo = "IanniX";
  #   rev = "f84becdcbe154b20a53aa2622068cb8f6fda0755";
  #   sha256 = "184ydb9f1303v332k5k3f1ki7cb6nkxhh6ij0yn72v7dp7figrgj";
  # };

  nativeBuildInputs = [ qt5.qmake ];
  buildInputs = [
    alsaLib
    EQL5
    ecl
    ffmpeg
    pkgconfig
    qt5.qtbase
    qt5.qtscript ];


  # preConfigure = "
  # eql5 make-ASDF";

  qmakeFlags = [ "PREFIX=/" ];

  postInstall = ''
  mkdir -p $out/bin/Tools
  cp -r $PWD/Tools $out/bin


'';



  installFlags = [ "INSTALL_ROOT=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "Graphical open-source sequencer,";
    homepage = https://www.iannix.org/;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
