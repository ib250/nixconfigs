{ pkgs ? import <nixpkgs> { }, jdk ? pkgs.jdk11 }:
let
  owner = "fwcd";
  repo = "kotlin-language-server";
  version = "0.7.0";
  sha256 = "0by07h2ly84dzmwzjf3fsgghm3fwhyhhbnnv3kl7dy1iajhl4shj";

in pkgs.stdenv.mkDerivation {

  name = repo;
  inherit version;
  src = pkgs.fetchFromGitHub {
    rev = version;
    inherit owner repo sha256;
  };

  propagatedBuildInputs = [ jdk ];
  buildPhase = ''
    ./gradlew :server:installDist
  '';

  installPhase = ''
    mkdir -p $out
    mv server/build/install/server/bin $out/.
    mv server/build/install/server/lib $out/.
  '';

}
