local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
vim.fn.mkdir(parser_install_dir, "p")
vim.opt.runtimepath:append(parser_install_dir)

require("nvim-treesitter.install").prefer_git = true

require'nvim-treesitter.configs'.setup {
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
    parser_install_dir = parser_install_dir
}

require("spellsitter").setup {
    enable = true,
    debug = false
}
