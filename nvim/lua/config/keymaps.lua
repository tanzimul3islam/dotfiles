-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<leader>p", '<cmd>lua require("cmp").setup { enabled = true }<cr>', { desc = "Enable completion" })
vim.keymap.set(
  "n",
  "<leader>P",
  '<cmd>lua require("cmp").setup { enabled = false }<cr>',
  { desc = "Disable completion" }
)

-- map esc to jk for laptop use
-- vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape jk" })

-- insert the date in my desired configuration
vim.keymap.set("n", "<leader>d", "<cmd>r!gendate<cr>", { desc = "Insert date" })
vim.keymap.set("n", "<leader>h1", "<cmd>r!gendate h 1<cr>", { desc = "Insert date h1" })
vim.keymap.set("n", "<leader>h2", "<cmd>r!gendate h 2<cr>", { desc = "Insert date h2" })

-- lsp
vim.keymap.set("n", "<leader>S", "<cmd>LspStop<CR>", { desc = "LspStop" })

-- surrounding words
vim.keymap.set("n", "<leader>wsq", 'ciw""<Esc>P', { desc = "Word Surround Quotes" })

-- replaces
vim.keymap.set("n", "<leader>rbs", "<cmd>%s/\\//g<CR>", { desc = "Replace Backward Slash" })

-- telescope symbols
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope symbols<cr>", { desc = "Find Symbols" })

-- convert Current line to title cases
vim.keymap.set(
  "n",
  "<leader>rlt",
  "<cmd>lua require('textcase').current_word('to_title_case')<CR>",
  { desc = "Replace Line Title" }
)
-- vim.keymap.set("n", "<leader>rlt", "<cmd>s/<./\u&/g<cr>", { desc = "Replace Line Title" })

-- these keep the cursor in the middle when scrolling with ctrl d and u
-- from https://github.com/ThePrimeagen/init.lua
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- and these are for searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- competitive programming
vim.keymap.set("n", "<leader>tt", "<cmd>CompetiTest run<CR>", { desc = "CP run tests" })
vim.keymap.set("n", "<leader>ta", "<cmd>CompetiTest add_testcase<CR>", { desc = "CP add testcase" })
vim.keymap.set("n", "<leader>te", "<cmd>CompetiTest edit_testcase<CR>", { desc = "CP edit testcase" })

-- nvim go related
vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Go Test" })

-- snippets

vim.keymap.set("n", "<leader>hy", "i{{< youtube id >}}<Esc>", { desc = "Hugo Youtube" })

-- Disable middle-click paste (primary selection) to prevent garbage from Claude terminal
vim.keymap.set('i', '<MiddleMouse>', '<Nop>', { desc = "Disable middle-click paste (insert)" })
vim.keymap.set('n', '<MiddleMouse>', '<Nop>', { desc = "Disable middle-click paste (normal)" })
vim.keymap.set('x', '<MiddleMouse>', '<Nop>', { desc = "Disable middle-click paste (visual)" })
vim.keymap.set('c', '<MiddleMouse>', '<Nop>', { desc = "Disable middle-click paste (command)" })
