{
  busybox = import <nix/fetchurl.nix> {
    url = "http://192.168.10.4/~viric/tmp/nix/busybox";
    sha256 = "1z5zaa7cs70sndfcpabfhlw4ralzcjv1qhii2vi20vng3ldn2bwm";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://192.168.10.4/~viric/tmp/nix/bootstrap-tools.tar.xz";
    sha256 = "c1ecedab5d7e0939b7f06142c644061a152659d841f3732d37cd6d5c32e98db3";
  };
}
