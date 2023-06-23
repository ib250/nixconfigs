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
  autocmd FileType lua setlocal shiftwidth=2 tabstop=2 expandtab
augroup end
]]
