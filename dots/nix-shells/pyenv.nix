{ python-version, enable-aws ? false }:

let
    pkgs = import <nixpkgs> { };
    from = where: what: builtins.getAttr what where;
    python = from pkgs "python${python-version}";
    pypi = from pkgs "python${python-version}Packages";

    withAwsExtras = { buildInputs, ... }@shell: {
        buildInputs = (buildInputs ++ [ pypi.boto3 pypi.ipython pypi.matplotlib ]);
        shellHook = shell.shellHook;
    };

    stdPythonEnv = (_: with pypi; [ tox pip virtualenv setuptools ]);

    envDef = {

        buildInputs = [
            (python.withPackages stdPythonEnv) pkgs.poetry pkgs.pipenv
        ];

        shellHook = ''
            unset SOURCE_DATE_EPOCH
        '';

        meta = with pkgs.stdenv.lib; {
            homepage = "https://github.com/ib250";
            description = "A minimal nix version of pyenv for linux and osx";
            license = licenses.mit;
            platforms = platforms.linux ++ platforms.darwin;
        };

    };

in pkgs.mkShell (if enable-aws then (withAwsExtras envDef) else envDef)
