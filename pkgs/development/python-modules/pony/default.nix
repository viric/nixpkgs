{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fqc45m106xfy4hhzzwb8p7s2fh5x2x7s143dib84lbszqwp77la";
  };
}
