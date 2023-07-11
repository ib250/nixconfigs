{
  plugins.nvim-cmp = {
    enable = true;
    sources = [
      {name = "nvim_lua";}
      {name = "nvim_lsp";}
      {name = "nvim_lsp_document_symbol";}
      {name = "nvim_lsp_signature_help";}
      {name = "luasnip";}
      {name = "path";}
      {name = "buffer";}
    ];
    performance.maxViewEntries = 10;
    mappingPresets = ["insert"];
    autoEnableSources = true;
    formatting.fields = ["kind" "abbr" "menu"];
    window = rec {
      completion = {
        winhighlight = "Normal:Penu,FloatBorder:Pmenu,Search:None";
      };
      documentation = completion;
    };
    snippet.expand = "luasnip";
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp_luasnip.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-nvim-lsp-document-symbol.enable = true;
  plugins.cmp-nvim-lsp-signature-help.enable = true;
  plugins.cmp-nvim-lua.enable = true;
  plugins.cmp-spell.enable = true;
  plugins.cmp-treesitter.enable = true;
  plugins.cmp-zsh.enable = true;
  plugins.luasnip.enable = true;
}
