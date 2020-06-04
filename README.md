*nix configuration

./configuration.nix -> /etc/nixos/configuration.nix
./common.nix        -> /etc/nixos/common.nix


./home.nix   -> ~/.config/nixpkgs/home.nix
./common.nix -> ~/.config/nixpkgs/common.nix

nix-channel --add home-manager https://github.com/rycee/home-manager/archive/release-20.03.tar.gz


./dots/nix-shells/* -> ~/.config/nix-shells/*


pyenv.nix () {
	case $1 in
		use ) shift && nix-shell ~/.config/nix-shells/pyenv.nix --argstr python-version "$@";;
		* ) nix-shell ~/.config/nix-shells/pyenv.nix "$@";;
	esac
}
