{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "btsdu";
  version = "20201208";

  src = fetchFromGitHub {
    owner = "rkapl";
    repo = pname;
    rev = "e113e9f347c7d84080f00188a8ac3dd15575e18e";
    sha256 = "01mqrws1n8sqpadv3iq2id2z7hkrm64y3q48jci7ddnywclk7bw0";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "04bmak8cxgw59ak6s9v5wdc2lms55pg84j69h4namcn2wyd08cji";

  meta = with stdenv.lib; {
    description = "Btrfs Snapshot Disk Usage Analyzer";
    homepage = "https://github.com/rkapl/btsdu";
    license = with licenses; [ gpl2 ];
    platforms = platforms.linux;
  };
}
