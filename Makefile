
link-home:
	cp -rsf $(shell pwd)/{home.nix,packages} ~/.config/nixpkgs/.

dot-nvim:
	git clone https://github.com/doom-neovim/doom-nvim ~/.config/nvim
ifeq ($(bootstrap), true)
	git --git-dir ~/.config/nvim/.git checkout v4.1.0 -b ib250
endif

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
