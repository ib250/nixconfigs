require "telescope".setup {
    defaults = require("telescope.themes").get_dropdown {
        path_display = { "truncate" }
    },
    extensions = {
        file_browser = {
            depth = 1,
            hijack_netrw = true,
            grouped = true,
            dir_icon = "+",
            browse_folders = true,
            repsect_gitignore = true,
        }
    }
}

require("telescope").load_extension "file_browser"

local tb = require("telescope.builtin")
vim.keymap.set(
    "n",
    "<C-f>",
    function()
        local workspace_folders = vim.lsp.buf.list_workspace_folders()
        tb.find_files {
            cwd = workspace_folders[1],
            search_dirs = workspace_folders
        }
    end,
    { noremap = true }
)
vim.keymap.set("n", "<C-p>", tb.git_files, { noremap = true })
vim.keymap.set("n", "<leader>r", tb.oldfiles, { noremap = true })
vim.keymap.set("n", "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<cr><ESC>", { noremap = true })
vim.keymap.set(
    "n",
    "<leader>ag",
    function()
        tb.grep_string(
            require("telescope.themes").get_ivy {
                theme = "ivy",
                search_dirs = vim.lsp.buf.list_workspace_folders()
            }
        )
    end,
    { noremap = true }
)
vim.keymap.set("n", "<leader>gs", tb.git_status, { noremap = true })
vim.keymap.set("n", "<leader>gb", tb.git_branches, { noremap = true })
vim.keymap.set("n", "<space><space>", tb.buffers, { noremap = true })
