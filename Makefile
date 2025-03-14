
lock:
	nix flake lock
	nix flake show

develop:
	nix develop

update:
	nix flake update
	
format:
	nix fmt .

sync: format
	git commit -am "sync"
	git push

use:
	nix run -j8 home-manager/release-24.05 -- init --switch . --show-trace

use-home: use

use-darwin:
	nix run -j8 nix-darwin/master -- switch --flake . --show-trace


.phony: lock develop update format sync use-home use-darwin use
