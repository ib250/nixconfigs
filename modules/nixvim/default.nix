{ pkgs, ... }:
{
  enable = true;
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
    backspace = [ "indent" "eol" "start" ];
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
    completeopt = [ "menuone" "menu" "longest" ];
    autochdir = true;
  };

  extraConfigLuaPre = builtins.readFile ./lua/before.lua;
  extraConfigLuaPost = builtins.readFile ./lua/after.lua;
  colorschemes.catppuccin.enable = true;
  plugins = {
    todo-comments.enable = true;
    treesitter = {
      enable = true;
      folding = true;
      indent = true;
      moduleConfig.autotag.enable = true;
      nixvimInjections = true;
    };

    comment-nvim.enable = true;
    gitsigns.enable = true;
    which-key.enable = true;

    lsp.enable = true;
    lsp.servers = {
      pyright.enable = true;
      bashls.enable = true;
      clangd.enable = true;
      gopls.enable = true;
      jsonls.enable = true;
      lua-ls.enable = true;
      metals.enable = true;
      nil_ls.enable = true;
      ruff-lsp.enable = true;
      rust-analyzer.enable = true;
      tsserver.enable = true;
      yamlls.enable = true;
    };

    lsp-format.enable = true;
    lsp-lines = {
      enable = false;
      currentLine = true;
    };

    lspkind = {
      enable = true;
      mode = "symbol_text";
      cmp.ellipsisChar = "...";
      cmp.menu = {
        buffer = "[Buffer]";
        nvim_lsp = "[LSP]";
        nvim_lua = "[Lua]";
        latex_symbols = "[Latex]";
      };
      cmp.after = ''
        function(entry, vim_item, kind)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          if #strings == 2 then
            kind.kind = " " .. strings[1] .. " "
            kind.menu = "   " .. strings[2]
          end

          return kind
        end
      '';
    };

    nvim-cmp = {
      enable = true;
      performance.maxViewEntries = 10;
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "nvim_lsp_document_symbol"; }
        { name = "nvim_lsp_signature_help"; }
        { name = "vim_lsp"; }
        { name = "nvim_lua"; }
      ];
      mappingPresets = [ "insert" ];
      mapping = { "<CR>" = "cmp.mapping.confirm({ select = true })"; };
      autoEnableSources = true;
      formatting.fields = [ "kind" "abbr" "menu" ];

      window.completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
      };

      window.documentation = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
      };

      snippet.expand = "luasnip";

    };
    null-ls = {
      enable = true;
      shouldAttach = ''function(bufnr)
        return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      end
      '';
      sources = {
        code_actions.shellcheck.enable = true;
        code_actions.statix.enable = true;
        diagnostics.cppcheck.enable = true;
        diagnostics.deadnix.enable = true;
        diagnostics.flake8.enable = true;
        diagnostics.gitlint.enable = true;
        diagnostics.shellcheck.enable = true;
        diagnostics.statix.enable = true;
        formatting.alejandra.enable = true;
        formatting.black.enable = true;
        formatting.nixfmt.enable = true;
        formatting.nixpkgs_fmt.enable = true;
        formatting.prettier.enable = true;
        formatting.shfmt.enable = true;
        formatting.stylua.enable = true;
        formatting.taplo.enable = true;
      };
    };

    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };

    treesitter-refactor.enable = true;
    rust-tools.enable = true;
  };

  extraPackages = with (import ../devTools.nix { inherit pkgs; }); allDevtools;
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.mini-nvim;
      config = builtins.readFile ./lua/mini.lua;
    }
  ];
}
