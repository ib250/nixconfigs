local tb = require("telescope.builtin")

vim.keymap.set("n", "<C-f>", tb.find_files, {})
vim.keymap.set("n", "<C-p>", tb.git_files, {})
vim.keymap.set("n", "<C-n>", tb.oldfiles, {})
vim.keymap.set("n", "<leader>ag", function()
	tb.grep_string({ search = vim.fn.input("grep > ") });
end)
