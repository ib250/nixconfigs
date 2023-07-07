nix_with_flakes=NIX_CONFIG="experimental-features = nix-command flakes" NIXPKGS_ALLOW_UNFREE=1 nix

lock:
	$(nix_with_flakes) flake lock
	$(nix_with_flakes) flake show --all-systems

# TODO: flakify
link-nixos:
	cp -rsf ./{configuration.nix,packages} /etc/nixos/.

switch:
	$(nix_with_flakes) run $(if $(debugger),--debugger,) \
		home-manager/master -- \
		switch --flake '.?submodules=1' --show-trace

develop:
	$(nix_with_flakes) develop

update:
	nix flake update
	
format:
	nix run nixpkgs#nixfmt -- -w 80 home.nix modules/*.nix

sync: format
	git commit -am "sync"
	git push


.phony: link-home link-nixos install switch update sync
