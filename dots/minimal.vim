let g:mapleader = ";"
set noswapfile
set number
set rnu
set clipboard=unnamed
set wildmenu
set wildmode=longest,full
set ignorecase
set smartcase
set hlsearch
set incsearch
set foldenable
set foldmethod=indent
set foldnestmax=10
set encoding=utf8
set foldlevel=0
set ffs=unix,mac,dos
set ff=unix

imap jk <ESC>
imap kj <ESC>
imap <leader><tab> <c-x><c-i>
nmap <leader>bn: bNext<Enter>
nmap <leader>bd: bdelete<Enter>
nmap <leader>l: <c-w>
nmap <C-n> :NERDTreeToggle<Enter>

set completeopt=menuone,menu,longest,preview
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

colorscheme desert
