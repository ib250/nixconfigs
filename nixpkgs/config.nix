{
    allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {

        myPythonPackages = pkgs.buildEnv {
            name = "my-python-packages";
            paths = [
                python37Packages.jupyter
                python37Packages.virtualenv
                python37Packages.virtualenvwrapper
                python37Packages.coverage
                python37Packages.hypothesis
                python37Packages.pytest
                python37Packages.pytest-sugar
            ];
        };

        /*
        userPackages = pkgs.buildEnv {
            name = "user-packages";
            paths = [ (import ./vim.nix) ];
        };*/

        usefulNixTools = pkgs.buildEnv {
            name = "useful-nix-tools";
            paths = [
                nox
                nix-index
                nix-repl
            ];
        };

        /*
        disposables = pkgs.buildEnv {
            name = "disposables";
            paths = [ nodejs ];
        };*/

    };
}
