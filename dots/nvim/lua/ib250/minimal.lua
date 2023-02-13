vim.g.mapleader = ";"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.wildmenu = true
vim.opt.foldenable = true
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.encoding = "utf8"
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 99

vim.opt.ffs = {"unix","mac", "dos"}
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.backspace={ "indent", "eol","start"}
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.shellslash = true

vim.opt.lazyredraw = true
vim.opt.cursorline = false

vim.opt.scrolljump=5
vim.opt.re=1
vim.opt.scrolloff=3
vim.opt.laststatus=1

vim.opt.errorbells = false
vim.opt.visualbell = false

vim.opt.completeopt = {"menuone", "menu", "longest"}
vim.opt.wildignore = {"*/tmp/*","*.so","*.swp", "*.zip"}

vim.opt.autochdir = true
vim.cmd [[
augroup vimrc_set_working_dir
  au!
  autocmd BufEnter * silent! lcd %:p:h
augroup end
]]

vim.cmd [[
augroup vimrc_set_numbering
  au!

  if has('nvim')
    autocmd TermOpen * :setlocal norelativenumber nonumber
  elseif has('terminal')
    autocmd TerminalOpen * :setlocal norelativenumber nonumber
  endif

  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber
augroup end
]]

vim.cmd [[
augroup vimrc_file_type_indentation
  au!
  autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 expandtab
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType haskell setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType elm setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType nix setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType vim setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType matlab setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 expandtab
augroup end
]]

vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")
vim.keymap.set("c", "jk", "<ESC>")
vim.keymap.set("c", "kj", "<ESC>")

vim.keymap.set("v", "jk", "<ESC>")
vim.keymap.set("v", "kj", "<ESC>")

vim.keymap.set("i", "<leader><tab>", "<c-x><c-i>")
vim.keymap.set("n", "<leader>bn", ":bNext<cr>")
vim.keymap.set("n", "<leader>bd", ":bdelete<cr>")
vim.keymap.set("n", "<leader>q", ":q<cr>")
vim.keymap.set("n", "<leader>w", ":w!<cr>")
vim.keymap.set("n", "<leader><space>", ":noh<cr>")
