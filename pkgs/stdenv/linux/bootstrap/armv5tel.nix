{
  busybox = import <nix/fetchurl.nix> {
    url = "http://192.168.10.4/~viric/tmp/nix/busybox";
    sha256 = "1vfadk3d2v0bsvmbaz1pvpn4g1vm7p751hkdxya1lkn5n1a9px5m";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://192.168.10.4/~viric/tmp/nix/bootstrap-tools.tar.xz";
    sha256 = "39df65053bab50bc2975060c4da177266e263f30c2afba231a97d23f4c471eb8";
  };
}
