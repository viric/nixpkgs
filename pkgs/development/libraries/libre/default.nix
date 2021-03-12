{lib, stdenv, fetchFromGitHub, zlib, openssl}:
stdenv.mkDerivation rec {
  version = "1.1.0";
  pname = "libre";
  src = fetchFromGitHub {
    owner  = "baresip";
    repo   = "re";
    rev    = "v${version}";
    sha256 = "0p4rmch6rxf1igkyb9mdi86s4kp3xx05c9irv8ixym3f5xlkk7id";
  };
  enableParallelBuilding = true;
  buildInputs = [ zlib openssl ];
  makeFlags = [ "USE_ZLIB=1" "USE_OPENSSL=1" "PREFIX=$(out)" ]
  ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${stdenv.cc.cc}"
  ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    description = "A library for real-time communications with async IO support and a complete SIP stack";
    homepage = "http://www.creytiv.com/re.html";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.bsd3;
    inherit version;
    downloadPage = "http://www.creytiv.com/pub/";
    updateWalker = true;
    downloadURLRegexp = "/re-.*[.]tar[.].*";
  };
}
