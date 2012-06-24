{ fetchurl, stdenv, unzip, ant, javac, jvm }:

let
  version = "1.7R3";
  options = "-Dbuild.compiler=gcj";   # FIXME: We assume GCJ here.

  xbeans  = fetchurl {
    url = "http://www.apache.org/dist/xmlbeans/binaries/xmlbeans-2.5.0.zip";
    sha256 = "0j1lmbzncxa4m5wiw659wmdsi725s87kqapg6rakc9qrwxrxx775";
  };
in
  stdenv.mkDerivation {
    name = "rhino-${version}";

    src = fetchurl {
      url = "ftp://ftp.mozilla.org/pub/mozilla.org/js/rhino1_7R3.zip";
      sha256 = "1ldc7m58xs4g1s3bxqc99cmdkmlpin7f1i8j6ynj7bz59zi4cnw8";
    };

    # patches = [ ./gcj-type-mismatch.patch ];

    preConfigure =
      '' find -name \*.jar -or -name \*.class -exec rm -v {} \;

         # The build process tries to download it by itself.
         mkdir -p "build/tmp-xbean"
         ln -sv "${xbeans}" "build/tmp-xbean/xbean.zip"
      '';

    buildInputs = [ unzip ant javac jvm ];

    buildPhase = "ant ${options} jar";
    doCheck    = false;

    # FIXME: Install javadoc as well.
    installPhase =
      '' mkdir -p "$out/lib/java"
         cp -v *.jar "$out/lib/java"
      '';

    meta = {
      description = "Mozilla Rhino: JavaScript for Java";

      longDescription =
        '' Rhino is an open-source implementation of JavaScript written
           entirely in Java.  It is typically embedded into Java applications
           to provide scripting to end users.
        '';

      homepage = http://www.mozilla.org/rhino/;

      licenses = [ "MPLv1.1" /* or */ "GPLv2+" ];

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
