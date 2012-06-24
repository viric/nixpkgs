/* XXX: This is work in progress and it needs your help!  */

/* See http://icedtea.classpath.org/wiki/BuildRequirements for a
   list of dependencies.  */

{ fetchurl, stdenv, which
, wget, cpio, file, ecj, gcj, ant, gawk, procps, inetutils, zip, unzip, zlib
, alsaLib, cups, lesstif, freetype, classpath, libjpeg, libpng, giflib
, xalanj, xerces, rhino
, libX11, libXp, libXtst, libXinerama, libXt, libXrender, xproto
, pkgconfig, xulrunner, pulseaudio, libxslt, lcms2, gtk, attr
, perl }:

let
  # These variables must match those in the top-level `Makefile.am'.
  baseUrl = "http://icedtea.classpath.org/hg/release/icedtea7-forest-2.2";
  openjdkChangeset = "0b776ef59474";
  hotspotChangeset = "889dffcf4a54";
  corbaChangeset = "38deb372c569";
  jaxpChangeset = "335fb0b059b7";
  jaxwsChangeset = "5471e01ef43b";
  jdkChangeset = "6c3b742b735d";
  langtoolsChangeset = "beea46c7086b";

  openjdk = fetchurl {
    url = "${baseUrl}/archive/${openjdkChangeset}.tar.gz";
    sha256 = "15a6eab62f5108efbf7937b1de7697bd789971886fc1fc08ee8199e16a5c10fe";
  };

  hotspot = fetchurl {
    url = "${baseUrl}/hotspot/archive/${hotspotChangeset}.tar.gz";
    sha256 = "b29a8929bb4aadbc033e99dca6a381ca6342f0373b9c3f67827bfc025187ba41";
  };

  corba = fetchurl {
    url = "${baseUrl}/corba/archive/${corbaChangeset}.tar.gz";
    sha256 = "b892b0db6f3e4f89fd480d46ecb7c9ce5c71a884ae5bfe953b4bda9eedf7ea93";
  };

  jaxp = fetchurl {
    url = "${baseUrl}/jaxp/archive/${jaxpChangeset}.tar.gz";
    sha256 = "ff4ab3710fe316b7adc4e57d4d21ff967ca20e2ccc5267ac26b93cd22db8b3fd";
  };

  jaxws = fetchurl {
    url = "${baseUrl}/jaxws/archive/${jaxwsChangeset}.tar.gz";
    sha256 = "1ef055749ee46ebf7a5be94403b461d8d32e95c98906da459aeb217a0784ff1d";
  };

  jdk = fetchurl {
    url = "${baseUrl}/jdk/archive/${jdkChangeset}.tar.gz";
    sha256 = "48a513d18c919ec08d44cffdc12ae65f1e8942924c6cfcca5c1ffa8ca38afd0e";
  };

  langtools = fetchurl {
    url = "${baseUrl}/langtools/archive/${langtoolsChangeset}.tar.gz";
    sha256 = "17055cf1490fab1cccc57bf3aa5b32d655c408859790c7f671bfde180ddf70cb";
  };

in

stdenv.mkDerivation rec {
  name = "icedtea-2.2.1";

  src = fetchurl {
    url = "http://icedtea.classpath.org/download/source/${name}.tar.gz";
    sha256 = "1dh0lb6pw7w0sjrjwn9iqizhfv5ns5nj2idk98vm0z2gj1is2nqg";
  };

  buildInputs = [
    wget  # Not actually used, thanks to `--with-openjdk-src-zip' et al.
    which cpio file ecj gcj ant gawk procps inetutils zip unzip zlib
    alsaLib cups lesstif freetype classpath libjpeg libpng giflib
    xalanj xerces
    libX11 libXp libXtst libXinerama libXt libXrender xproto
    pkgconfig /* xulrunner */ pulseaudio
    libxslt lcms2 gtk attr perl
  ];

  preConfigure = ''
      # Use the Sun-compatible tools (`jar', etc.).
      export PATH="${gcj.gcc}/lib/jvm/bin:$PATH"
    '';

  buildPhase = ''
      make || true
      sed -i s,/usr/bin/perl,${perl}/bin/perl, bootstrap/jdk1.6.0/bin/java?
      make
    '';

  configureFlags =
    stdenv.lib.concatStringsSep " "
      [
        "--with-ecj" "--with-ecj-jar=${ecj}/lib/java/ecj.jar"
        "--with-javac=${ecj}/bin/ecj"
        "--with-openjdk-src-zip=${openjdk}"
        "--with-hotspot-src-zip=${hotspot}"
        "--with-corba-src-zip=${corba}"
        "--with-jdk-src-zip=${jdk}"
        "--with-langtools-src-zip=${langtools}"
        "--with-jaxp-src-zip=${jaxp}"
        "--with-jaxws-src-zip=${jaxws}"
        "--with-jdk-home=${gcj.gcc}/lib/jvm"
        "--with-rhino=${rhino}/lib/java/js.jar"
      ];

  makeFlags =
    [ # Have OpenCDK use tools from $PATH.
      "ALT_UNIXCCS_PATH=" "ALT_UNIXCOMMAND_PATH=" "ALT_USRBIN_PATH="
      "ALT_COMPILER_PATH=" "ALT_DEVTOOLS_PATH="

      # Libraries.
      "ALT_MOTIF_DIR="
      "ALT_FREETYPE_HEADERS_PATH=${freetype}/include"
      "ALT_FREETYPE_LIB_PATH=${freetype}/lib"
      "ALT_CUPS_HEADERS_PATH=${cups}/include"
      "ALT_CUPS_LIB_PATH=${cups}/lib"
    ];

  meta = {
    description = "IcedTea, a libre Java development kit based on OpenJDK";

    longDescription =
      '' The IcedTea project provides a harness to build the source code from
         http://openjdk.java.net using Free Software build tools and adds a
         number of key features to the upstream OpenJDK codebase: a Free
         64-bit plugin with LiveConnect and Java Web Start support, support
         for additional platforms via a pure interpreted mode in HotSpot
         (Zero) or the alternative CACAO virtual machine.  Experimental JIT
         support for Zero is also available via Shark.
      '';

    license = "GPLv2"; /* and multiple-licensing, e.g., for the plug-ins */

    homepage = http://icedtea.classpath.org/;

    maintainers = [ stdenv.lib.maintainers.ludo ];

    # Restrict to GNU systems for now.
    platforms = stdenv.lib.platforms.gnu;
  };
}
