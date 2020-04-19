{ lib, buildPythonPackage, fetchPypi
, pytest, pyyaml, marshmallow
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13f0snaj0m5ligjqp0v0xrgv136vfjh3wj2hmz185qcrp1j0b7a1";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pyyaml marshmallow ];

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
  };
}
