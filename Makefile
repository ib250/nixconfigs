
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

UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
use:
	nix run -j8 nix-darwin/master -- switch --flake . --show-trace
else
use:
	nix run -j8 home-manager/release-24.05 -- init --switch . --show-trace
endif

use-home:
	nix run -j8 home-manager/release-24.05 -- init --switch . --show-trace

use-darwin:
	nix run -j8 nix-darwin/master -- switch --flake . --show-trace


.phony: lock develop update format sync use-home use-darwin use
