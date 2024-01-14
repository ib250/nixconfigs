
lock:
	nix flake lock
	nix flake show

develop:
	nix develop

update:
	nix flake update
	
format:
	nix fmt

sync: format
	git commit -am "sync"
	git push

use-darwin:
	nix run nix-darwin/master -- switch --flake . --show-trace

use:
	nix run home-manager/release-23.11 -- init --switch . --show-trace


.phony: link-home link-nixos install switch update sync
