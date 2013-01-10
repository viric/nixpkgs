{ fetchsvn, fetchurl, stdenv, wxGTK29, freeimage, cmake, zziplib, mesa, boost,
  pkgconfig, libuuid, openal, ogre, ois, curl, gtk, pixman, mygui, unzip,
  angelscript, caelum, ogrepaged, mysocketw, libxcb
  }:

stdenv.mkDerivation rec {
  version = "0.4.0.4";
  name = "rigsofrods-${version}";

  src = fetchurl {
    url = mirror://sourceforge/rigsofrods/rigsofrods-source-0.4.0.4.tar.bz2;
    sha256 = "0gz4wavcaspf42wjm7f2w503yr0ypv46mmqqdr2p1azvkjlrm60d";
  };

  contentPackSrc = fetchurl {
    url = mirror://sourceforge/rigsofrods/rigsofrods/0.37/content-pack-0.37.zip;
    sha256 = "0prvn8lxqazadad4mv0nilax9i4vqb9s7dp7mqzvqc0ycmcnf4ps";
  };

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DROR_USE_CURL=TRUE"
    "-DROR_USE_MYGUI=TRUE"
    "-DROR_USE_OPNEAL=TRUE"
    "-DROR_USE_CAELUM=TRUE"
    "-DROR_USE_PAGED=TRUE"
    "-DROR_USE_ANGELSCRIPT=TRUE"
    "-DROR_USE_SOCKETW=TRUE"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # To get a proper rpath in RoR, since boost > 1.49
  NIX_LDFLAGS = "-lboost_system";

  installPhase = ''
    sed -e "s@/usr/local/lib/OGRE@${ogre}/lib/OGRE@" -i ../tools/linux/binaries/plugins.cfg
    mkdir -p $out/share/rigsofrods
    cp -r ../bin/* $out/share/rigsofrods
    cp ../tools/linux/binaries/plugins.cfg $out/share/rigsofrods
    mkdir -p $out/bin
    ln -s $out/share/rigsofrods/{RoR,rorconfig} $out/bin
    cd $out/share/rigsofrods
    mkdir packs
    cd packs
    unzip "${contentPackSrc}"
  '';

  buildInputs = [ wxGTK29 freeimage cmake zziplib mesa boost pkgconfig
    libuuid openal ogre ois curl gtk mygui unzip angelscript
    caelum ogrepaged mysocketw libxcb ];

  meta = {
    description = "3D simulator game where you can drive, fly and sail various vehicles";
    homepage = http://rigsofrods.sourceforge.net/;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = with stdenv.lib.platforms; linux;
  };
}
