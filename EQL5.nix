with import "/home/jmsb/exps/nixpkgs" {};
let
  ccLibPath = lib.makeLibraryPath [stdenv.cc.cc.lib];

in stdenv.mkDerivation rec {
   NIX_CFLAGS_COMPILE = [ "-fPIC" ];
  src = fetchgit {
    url = "https://gitlab.com/eql/EQL5.git";
    rev = "955734e192438235c04e044b01955cb6295f3414";
    sha256 = "0l96i9pqlx5qpg40ddi6542l2srlacyy0k1s5wc8iwlwpkfa1ypv";
  };
  name = "eql5";
  buildInputs = [
    pkgs.ecl
    makeWrapper
    pkgs.qt5.qtbase
    pkgs.qt5.qttools
    pkgs.qt5.qtmultimedia
    pkgs.qt5.qtquickcontrols
    pkgs.qt5.qtsvg
    pkgs.qt5.qtwebkit
    pkgs.qt5.qtwebengine
    pkgs.qt5.qtconnectivity
    pkgs.qt5.qtwebsockets
    pkgs.qt5.qtwebchannel
    # pkgs.xorg.xcb
    pkgs.xorg.xkbcomp
    pkgs.xorg.xorgserver
    pkgs.xkeyboard_config

  ];

  # propagatedUserEnvPkgs = [
  #   pkgs.ecl

  #   pkgs.qt5.qtbase
  #   pkgs.qt5.qttools
  #   pkgs.qt5.qtmultimedia
  #   pkgs.qt5.qtquickcontrols
  #   pkgs.qt5.qtsvg

  #   pkgs.qt5.qtwebkit
  #   pkgs.qt5.qtwebengine
  #   pkgs.qt5.qtconnectivity
  #   # pkgs.xorg.xcb
  #   pkgs.xorg.xkbcomp
  #   pkgs.xorg.xorgserver
  #   pkgs.xkeyboard_config

  # ];

  dontUseQmakeConfigure = true;

  buildPhase = ''
    runHook preConfigure
    cd src
    ecl -shell make
    qmake eql5.pro
    make
    cd ..
    # export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
    # echo `$LD_LIBRARY_PATH`
    # cd src
    # ../eql5 make-wrappers.lisp
    # touch tmp/eql.o
    # qmake eql_lib.pro
    # make
    # cd ..
    # cd src
  '';

  preFixup = ''
    rm -rf $(pwd)/../__nix_qt5__
  '';

  installPhase = ''
     mkdir -p $out/bin $out/lib/ $out/include/eql5 $out/include/gen $out/lib $out/slime

    echo `$src`
    cp -r $PWD/eql5 $out/bin/
    cp $PWD/src/eql5/dyn_object.h $out/include/eql5/
    cp $PWD/src/eql5/eql.h $out/include/eql5/
    cp $PWD/src/eql5/eql_fun.h $out/include/eql5/
    cp $PWD/src/eql5/eql_global.h $out/include/eql5/

    cp -r $PWD/lib $out/
    cp -r $PWD/slime $out/
    # ln -s $out/lib/eql/build-dir/eql $out/bin
    # ln -s $out/lib/eql/build-dir/src/*.h $out/include
    # ln -s $out/lib/eql/build-dir/src/gen/*.h $out/include/gen


    cp $PWD/libeql*.so* $out/lib

    # patchelf --set-rpath "${stdenv.lib.makeLibraryPath buildInputs}" $out/bin/eql5

    # for entry in $out/lib/*.so*; do
    #   patchelf --set-rpath "${stdenv.lib.makeLibraryPath buildInputs}" $entry
    # done

   wrapProgram $out/bin/eql5 \
      --set EQL_HOME "$out/" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms \
  '';




}
