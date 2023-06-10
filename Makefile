nix_with_flakes=NIX_CONFIG="experimental-features = nix-command flakes" nix

lock:
	$(nix_with_flakes) flake lock

link-home:
	cp -rsf $(shell pwd)/{home.nix,flake.nix,flake.lock,packages} \
		~/.config/nixpkgs/.

link-nixos:
	cp -rsf ./{configuration.nix,packages} /etc/nixos/.

install:
	$(nix_with_flakes) home-manager/master -- init --switch
	$(make) link-home
	$(make) switch

switch:
	$(nix_with_flakes) run home-manager/master -- switch

update:
	nix flake update
	
sync:
	nix run nixpkgs#nixfmt -- -w 80 **/*.nix
	git commit -am "sync"
	git push


.phony: link-home link-nixos install switch update sync
