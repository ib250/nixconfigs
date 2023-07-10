{
  plugins.lsp.enable = true;
  plugins.lsp.servers = {
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

  plugins.lsp-format.enable = true;
  plugins.lsp-lines = {
    enable = false;
    currentLine = true;
  };

  plugins.lspkind = {
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

  plugins.null-ls = {
    enable = true;
    shouldAttach = ''
      function(bufnr)
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

  plugins.rust-tools.enable = true;
}
