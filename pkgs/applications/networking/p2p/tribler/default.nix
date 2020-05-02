{ stdenv, fetchurl, pkgs, python3Packages, makeWrapper
, enablePlayer ? true, libvlc ? null, qt5, lib }:

stdenv.mkDerivation rec {
  pname = "tribler";
  version = "7.5.0-rc5";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-v${version}.tar.xz";
    sha256 = "19b11cy3fnza5846lr2s5gxacqav212gs9w2hpz327f4p3p1pzj3";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    makeWrapper
  ];

  buildInputs = [
    python3Packages.python
  ];

  pythonPath = [
    python3Packages.libtorrentRasterbar
    python3Packages.twisted
    python3Packages.netifaces
    python3Packages.pycrypto
    python3Packages.pyasn1
    python3Packages.requests
    python3Packages.m2crypto
    python3Packages.pyqt5
    python3Packages.chardet
    python3Packages.cherrypy
    python3Packages.cryptography
    python3Packages.libnacl
    python3Packages.configobj
    python3Packages.decorator
    python3Packages.feedparser
    python3Packages.service-identity
    python3Packages.psutil
    python3Packages.pillow
    python3Packages.networkx
    python3Packages.pony
    python3Packages.lz4
    python3Packages.pyqtgraph
    python3Packages.pyyaml
    python3Packages.aiohttp
    python3Packages.aiohttp-apispec

    # there is a BTC feature, but it requires some unclear version of
    # bitcoinlib, so this doesn't work right now.
    # python3Packages.bitcoinlib
  ];

  postPatch = ''
    ${stdenv.lib.optionalString enablePlayer ''
      substituteInPlace "./src/tribler-gui/tribler_gui/vlc.py" --replace "ctypes.CDLL(p)" "ctypes.CDLL('${libvlc}/lib/libvlc.so')"
      substituteInPlace "./src/tribler-gui/tribler_gui/widgets/videoplayerpage.py" --replace "if vlc and vlc.plugin_path" "if vlc"
      substituteInPlace "./src/tribler-gui/tribler_gui/widgets/videoplayerpage.py" --replace "os.environ['VLC_PLUGIN_PATH'] = vlc.plugin_path" "os.environ['VLC_PLUGIN_PATH'] = '${libvlc}/lib/vlc/plugins'"
    ''}
  '';

  installPhase = ''
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${python3Packages.python}/bin/python $out/bin/tribler \
        --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms \
        --set _TRIBLERPATH $out/src \
        --set PYTHONPATH $out/src/tribler-core:$out/src/tribler-common:$out/src/tribler-gui:$program_PYTHONPATH \
        --set NO_AT_BRIDGE 1 \
        --run 'cd $_TRIBLERPATH' \
        --add-flags "-O $out/src/run_tribler.py" \
        ${stdenv.lib.optionalString enablePlayer ''
          --prefix LD_LIBRARY_PATH : ${libvlc}/lib
        ''}

    mkdir -p $out/share/applications $out/share/icons $out/share/man/man1
    cp $out/Tribler/Main/Build/Ubuntu/tribler.desktop $out/share/applications/tribler.desktop
    cp $out/Tribler/Main/Build/Ubuntu/tribler_big.xpm $out/share/icons/tribler.xpm
    cp $out/Tribler/Main/Build/Ubuntu/tribler.1 $out/share/man/man1/tribler.1
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ xvapx ];
    homepage = "https://www.tribler.org/";
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
