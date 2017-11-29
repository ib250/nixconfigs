{
    allowUnfree = true;

    packageOverrides = pkgs: with pkgs; {

        userPackages = pkgs.buildEnv {
            name = "user-packages";
            paths = [ (import ./vim.nix)
                      zip unzip
                      coreutils
                      zathura ];
        };

        disposables = pkgs.buildEnv {
            name = "disposables";
            paths = [ nodejs ];
        };

        devtools = pkgs.buildEnv {
            name = "devtools";
            paths = [zsync git libarchive
                     autoconf libtool gnumake
                     libtool fuse xzgv gnum4
                     glib openssl cmake 
                     inotifyTools lz4 gcc];
        };

    };
}
