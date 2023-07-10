{pkgs, ...}: {
  config = {
    globals.mapleader = ";";
    editorconfig.enable = true;
    options = {
      number = true;
      relativenumber = true;
      foldenable = false;
      foldminlines = 2;
      tabstop = 4;
      softtabstop = 4;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      wildmenu = true;
      encoding = "utf8";
      ruler = true;
      hidden = true;
      autoindent = true;
      backspace = ["indent" "eol" "start"];
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      shellslash = true;
      clipboard = "unnamedplus";
      lazyredraw = true;
      cursorline = false;
      errorbells = false;
      visualbell = false;
      completeopt = ["menuone" "menu" "longest"];
      autochdir = true;
    };
  };
}
