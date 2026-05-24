vim.api.nvim_create_autocmd("FileType", {
  desc = "Autostart treesitter just in case",
  group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  desc = "lspconfig setup",
  once = true,
  callback = function()
    vim.cmd.packadd("nvim-lspconfig")
    vim.cmd.packadd("blink.cmp")
    vim.cmd.packadd("clangd_extensions.nvim")
    vim.cmd.packadd("rustaceanvim")
    local blink = require("blink.cmp")
    blink.setup({
      keymap = { preset = "default" },

      appearance = { nerd_font_variant = "mono" },

      completion = { documentation = { auto_show = true } },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    })
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "telescope.nvim",
  once = true,
  group = vim.api.nvim_create_augroup("telescope.nvim", { clear = true }),
  callback = function()
    vim.cmd.packadd("telescope-frecency.nvim")
    vim.cmd.packadd("telescope-ui-select.nvim")
    vim.cmd.packadd("telescope-fzf-native.nvim")
    vim.cmd.packadd("telescope.nvim")

    local themes = require("telescope.themes")
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require("telescope").setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        layout_strategy = "flex",
      },

      history = { limit = 1000 },
      set_env = {
        ["COLORTERM"] = "truecolor",
      },
      -- pickers = {}
      extensions = {
        ["ui-select"] = {
          themes.get_dropdown({}),
        },
        frecency = {
          db_safe_mode = false,
        },
        fzf = {},
      },
    })

    vim.schedule(function()
      require("telescope").load_extension("frecency")
      vim.keymap.set(
        "n",
        "<leader>s.",
        "<CMD>Telescope frecency theme=dropdown<CR>",
        { desc = '[S]earch Recent Files ("." for repeat)' }
      )
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
    end)

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set(
      "n",
      "<leader>sh",
      builtin.help_tags,
      { desc = "[S]earch [H]elp" }
    )
    vim.keymap.set(
      "n",
      "<leader>sk",
      builtin.keymaps,
      { desc = "[S]earch [K]eymaps" }
    )
    vim.keymap.set(
      "n",
      "<leader>sf",
      builtin.find_files,
      { desc = "[S]earch [F]iles" }
    )
    vim.keymap.set(
      "n",
      "<leader>ss",
      builtin.builtin,
      { desc = "[S]earch [S]elect Telescope" }
    )
    vim.keymap.set(
      "n",
      "<leader>sw",
      builtin.grep_string,
      { desc = "[S]earch current [W]ord" }
    )
    vim.keymap.set(
      "n",
      "<leader>sg",
      builtin.live_grep,
      { desc = "[S]earch by [G]rep" }
    )
    vim.keymap.set(
      "n",
      "<leader>sd",
      builtin.diagnostics,
      { desc = "[S]earch [D]iagnostics" }
    )
    vim.keymap.set(
      "n",
      "<leader>sr",
      builtin.resume,
      { desc = "[S]earch [R]esume" }
    )
    vim.keymap.set(
      "n",
      "<leader><leader>",
      builtin.buffers,
      { desc = "[ ] Find existing buffers" }
    )

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(themes.get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      local ws_folders = vim.lsp.buf.list_workspace_folders() or {}
      builtin.live_grep({
        grep_open_files = #ws_folders == 0,
        prompt_title = "Live Grep",
        search_dirs = #ws_folders ~= 0 and ws_folders or nil,
      })
    end, { desc = "[S]earch [/] in Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })

    vim.keymap.set("n", "<C-f>", function()
      if pcall(builtin.git_files) then
        return
      end
      builtin.find_files()
    end, { desc = "Smart [F]ind [F]iles" })

    -- muscle memory
    vim.keymap.set("n", "<C-p>", vim.cmd.Telescope, { desc = "Open telescope" })
  end,
})
