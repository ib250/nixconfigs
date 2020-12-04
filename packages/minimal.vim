set nocompatible
set nobackup

syntax on
filetype plugin indent on

let g:mapleader = ";"

set noswapfile
set number
set rnu
set clipboard=unnamed
set wildmenu
set wildmode=longest,full
set foldenable
set foldmethod=indent
set foldnestmax=10
set encoding=utf8
set foldlevel=0
set foldlevelstart=99
set ffs=unix,mac,dos
set ruler
set hidden
set autoindent
set expandtab
set backspace=indent,eol,start
set ignorecase
set smartcase
set hlsearch
set incsearch
set shellslash
set tabstop=4
set shiftwidth=4
set lazyredraw
set scrolloff=3
set laststatus=1
set noerrorbells
set completeopt=menuone,menu,longest,preview
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

set autochdir
augroup vimrc_set_working_dir
  au!
  autocmd BufEnter * silent! lcd %:p:h
augroup end

if has('nvim')
  autocmd TermOpen * :setlocal norelativenumber nonumber
elseif has('terminal')
  autocmd TerminalOpen * :setlocal norelativenumber nonumber
endif

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

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

imap jk <ESC>
imap kj <ESC>
cmap jk <ESC>
cmap kj <ESC>
vmap jk <ESC>
vmap kj <ESC>

imap     <leader><tab>   <c-x><c-i>
nnoremap <leader>bn      :bNext<cr>
nnoremap <leader>bd      :bdelete<cr>
nnoremap <leader>q       :q<cr>
nnoremap <leader>w       :w!<cr>
nnoremap <leader><space> :noh<cr>
nnoremap <C-n>           :NERDTreeToggle<cr>

let g:ctrlp_cmd = 'CtrlPMRU'

colorscheme desert
