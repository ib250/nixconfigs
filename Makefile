nix_with_flakes=NIX_CONFIG="experimental-features = nix-command flakes" nix

lock:
	$(nix_with_flakes) flake lock
	$(nix_with_flakes) flake show --all-systems

# TODO: flakify
link-nixos:
	cp -rsf ./{configuration.nix,packages} /etc/nixos/.

install:
	$(nix_with_flakes) run home-manager/master -- init --switch . --show-trace

switch:
	$(nix_with_flakes) run home-manager/master -- switch --flake . --show-trace

develop:
	$(nix_with_flakes) develop

update:
	nix flake update
	
sync:
	nix run nixpkgs#nixfmt -- -w 80 **/*.nix
	git commit -am "sync"
	git push


.phony: link-home link-nixos install switch update sync
