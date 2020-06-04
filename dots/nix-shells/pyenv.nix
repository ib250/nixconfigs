{ python-version }:

let
  pkgs = import <nixpkgs> { };
  from = where: what: builtins.getAttr what where;
  python = from pkgs "python${python-version}";
  pypi = from pkgs "python${python-version}Packages";

  stdPythonEnv = (_:
    with pypi; [
      pip
      jedi
      flake8
      pynvim
      virtualenv
      setuptools
      python-language-server.override
      { pylint = null; }
    ]);

in pkgs.mkShell {

  buildInputs = [
      pkgs.poetry pkgs.pipenv pypi.tox pypi.virtualenv (python.withPackages stdPythonEnv)
  ];

  shellHook = "";

  meta = with pkgs.stdenv.lib; {
      homepage = "https://github.com/ib250";
      description = "A minimal nix version of pyenv for linux";
      license = licenses.mit;
      platforms = platforms.linux;
  };

}
