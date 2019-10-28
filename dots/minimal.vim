set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --creade-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'kien/rainbow_parentheses.vim'
Plug 'LnL7/vim-nix'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'https://github.com/lambdatoast/elm.vim.git'
Plug 'https://github.com/leafgarland/typescript-vim.git'
Plug 'vim-scripts/hlint'
Plug 'derekwyatt/vim-scala'
Plug 'neoclide/coc.nvim', { 'tag': '*', 'branch': 'release' }

call plug#end()

syntax on

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
set ff=unix
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

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

augroup vimrc_file_type_indentation
  au!
  autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 expandtab
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType haskell setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType elm setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType nix setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType vim setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType matlab setlocal shiftwidth=2 tabstop=2 expandtab
augroup end

imap jk <ESC>
imap kj <ESC>
cmap jk <ESC>
cmap kj <ESC>
vmap jk <ESC>
vmap kj <ESC>

imap <leader><tab> <c-x><c-i>
nnoremap <leader>bn: bNext<Enter>
nnoremap <leader>bd: bdelete<Enter>
nnoremap <leader>l: <c-w>
nnoremap <leader><space> :noh<cr>
nnoremap <leader>w :w!<cr>
nnoremap <C-n> :NERDTreeToggle<cr>

let g:ctrlp_cmd = 'CtrlPMRU'

filetype plugin indent on
colorscheme desert
