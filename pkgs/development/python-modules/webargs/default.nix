{ lib, buildPythonPackage, fetchPypi
, marshmallow, pytest, webtest
}:

buildPythonPackage rec {
  pname = "webargs";
  version = "5.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16pjzc265yx579ijz5scffyfd1vsmi87fdcgnzaj2by6w2i445l7";
  };

  buildInputs = [ pytest webtest ];
  propagatedBuildInputs = [ marshmallow ];

  doCheck = false;

  meta = with lib; {
    description = "Build and document REST APIs with aiohttp and apispec";
    homepage = "https://github.com/maximdanilchenko/aiohttp-apispec/";
    license = licenses.mit;
  };
}
