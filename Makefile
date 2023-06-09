
link-home:
	cp -rsf $(shell pwd)/{home.nix,packages} ~/.config/nixpkgs/.

link-nixos:
	cp -rsf ./{configuration.nix,packages} /etc/nixos/.

install:
	nix run .#homeConfigurations.default.activationPackage

switch:
	nix run .#homeConfigurations.default.activationPackage

update:
	nix flake update

sync:
	nix run nixpkgs#nixfmt -- -w 80 **/*.nix
	git commit -am "sync"
	git push


.phony: link-home link-nixos install switch update sync
