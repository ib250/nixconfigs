{
    allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {

        myPythonPackages = pkgs.buildEnv {
            name = "my-python-packages";
            paths = [
                python36Packages.jupyter
                python36Packages.virtualenv
                python36Packages.virtualenvwrapper
                python36Packages.coverage
                python36Packages.hypothesis
                python36Packages.pytest
                python36Packages.pytest-sugar ];
        };

        /*
        userPackages = pkgs.buildEnv {
            name = "user-packages";
            paths = [ (import ./vim.nix) ];
        };*/

        usefulNixTools = pkgs.buildEnv {
            name = "useful-nix-tools";
            paths = [nox nix-index nix-repl];
        };

        /*
        disposables = pkgs.buildEnv {
            name = "disposables";
            paths = [ nodejs ];
        };*/

    };
}
