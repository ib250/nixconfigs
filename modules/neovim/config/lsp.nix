{pkgs, ...}: {
  config = {
    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        clangd.enable = true;
        gopls.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        metals.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        pylsp = {
          enable = true;
          settings.plugins.pylsp_mypy.enabled = true;
          settings.plugins.ruff.enabled = true;
        };
        rust-analyzer.enable = true;
        tsserver.enable = true;
        yamlls.enable = true;
      };

      postConfig = builtins.readFile ./lua/lsp-post-config.lua;
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
        formatting.prettier.enable = true;
        formatting.shfmt.enable = true;
        formatting.stylua.enable = true;
        formatting.taplo.enable = true;
      };
    };

    extraPackages = [
      # null-ls programs
      pkgs.shellcheck
      pkgs.statix
      pkgs.cppcheck
      pkgs.deadnix
      pkgs.alejandra
      pkgs.shfmt
      pkgs.stylua
      pkgs.taplo
    ];

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = nlsp-settings-nvim;
        config = with import ./lib.nix;
          inlineLua ''
            require("nlspsettings").setup {
                config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
                local_settings_dir = ".nvim",
                local_settings_root_markers_fallback = { ".git" },
                append_default_schemas = true,
                loader = "json"
            }
          '';
      }
      {
        plugin = fidget-nvim;
        config = with import ./lib.nix;
          inlineLua ''
            require('fidget').setup()
          '';
      }
    ];
  };
}
