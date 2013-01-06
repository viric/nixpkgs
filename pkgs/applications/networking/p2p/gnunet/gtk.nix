{ stdenv, fetchurl, glib, gtk, libextractor, pkgconfig, libunique, libglade }:

stdenv.mkDerivation rec {
  name = "gnunet-gtk-0.9.5";

  src = fetchurl {
    url = "mirror://gnu/gnunet/${name}.tar.gz";
    sha256 = "1ymdcx1jj9w2mxmdfpw2n2j9idqxbsy3vzim1l5hkfw1ydc3k677";
  };

  buildInputs = [ glib gtk libextractor pkgconfig libglade ];

  doCheck = false;

  meta = {
    description = "GNUnet, GNU's decentralized anonymous and censorship-resistant P2P framework";
    homepage = http://gnunet.org/;

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
