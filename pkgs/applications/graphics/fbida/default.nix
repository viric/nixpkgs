{ stdenv, fetchurl, libjpeg, libexif, libungif, libtiff, libpng, libwebp
, pkgconfig, freetype, fontconfig, which, imagemagick, curl, saneBackends
}:

let
  commonBuildInputs =
    [ libexif libjpeg libpng libungif freetype fontconfig libtiff libwebp
      curl ];
in

stdenv.mkDerivation rec {
  name = "fbida-2.09";
  
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "1riia87v5nsx858xnlvc7sspr1p36adjqrdch1255ikr5xbv6h6x";
  };

  buildNativeInputs = [ pkgconfig which ];

  buildInputs = commonBuildInputs ++ [ imagemagick saneBackends ];
  
  makeFlags = [ "prefix=$(out)" "verbose=yes" ];

  patchPhase =
    ''
    sed -e 's@ cpp\>@ gcc -E -@' -i GNUmakefile
    '';

  configurePhase = "make config $makeFlags";

  crossAttrs = {
    makeFlags = makeFlags ++ [ "CC=${stdenv.cross.config}-gcc" "STRIP="];
    propagatedBuildInputs = commonBuildInputs;
  };

  meta = {
    description = "Image viewing and manipulation programs";
  };
}
