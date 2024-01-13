nix_with_flakes=NIX_CONFIG="experimental-features = nix-command flakes" NIXPKGS_ALLOW_UNFREE=1 nix

UNAME := $(shell uname)

lock:
	$(nix_with_flakes) flake lock
	$(nix_with_flakes) flake show

develop:
	$(nix_with_flakes) develop

update:
	nix flake update
	
format:
	nix fmt

sync: format
	git commit -am "sync"
	git push

use:
ifeq ($(UNAME), Darwin)
	nix run nix-darwin -- switch --flake .
else
	echo TODO: Just do home-manager...
endif


.phony: link-home link-nixos install switch update sync
