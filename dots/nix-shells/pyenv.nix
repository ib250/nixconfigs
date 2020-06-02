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

  buildInputs = [ pypi.tox pypi.virtualenv (python.withPackages stdPythonEnv) ];

  shellHook = "";

}
