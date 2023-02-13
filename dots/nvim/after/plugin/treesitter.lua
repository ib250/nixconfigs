require("nvim-treesitter.install").prefer_git = true

require'nvim-treesitter.configs'.setup {
	ensure_installed = "all",
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	}
}

require("spellsitter").setup {
    enable = true,
    debug = false
}
