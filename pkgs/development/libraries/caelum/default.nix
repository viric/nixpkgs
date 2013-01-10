{ stdenv, fetchhg, cmake, pkgconfig, ois, ogre, boost }:

stdenv.mkDerivation rec {
  name = "caelum-hg-20121122";

  src = fetchhg {
    url = https://code.google.com/p/caelum/;
    tag = "3b0f1afccf5c";
    sha256 = "1zishgxn7gqv9bfkii2ahxvydj4894grwpl80134a9fvzgh954yz";
  };

  buildInputs = [ ois ogre boost ];
  buildNativeInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    description = "Add-on for the OGRE, aimed to render atmospheric effects";
    homepage = http://code.google.com/p/caelum/;
    license = "LGPLv2.1+";
  };
}
