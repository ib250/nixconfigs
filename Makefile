nix_with_flakes=NIX_CONFIG="experimental-features = nix-command flakes" NIXPKGS_ALLOW_UNFREE=1 nix

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


.phony: link-home link-nixos install switch update sync
