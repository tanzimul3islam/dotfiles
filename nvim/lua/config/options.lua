-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- try this: vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

opt.ignorecase = true

-- scrolling
opt.number = false
opt.relativenumber = false
opt.scrolloff = 8

-- wrap / break

-- opt.textwidth = 80
-- opt.linebreak = true

-- indentation

-- o.expandtab = true              -- convert tabs to spaces
-- o.tabstop = 4                   -- insert 4 spaces for a tab
-- o.shiftwidth = 4                -- the number of spaces inserted for each indentation
-- o.smartindent = true

-- windows
-- vim.o.splitbelow = true
-- vim.o.splitright = true

-- completion
-- vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete
--
-- g.vim_markdown_conceal = 0
--
--
-- opt.vim_markdown_conceal = 0
--
-- vim.g.mkdp_browser = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"

vim.g.lazygit_config = false

vim.g.snacks_animate = false

-- Pin the clipboard provider to wl-clipboard so Neovim never falls back to
-- OSC 52 (which corrupts copy/paste inside the Claude terminal). With an
-- explicit provider, unnamedplus is safe: y/p go straight to wl-copy/wl-paste.
opt.clipboard = "unnamedplus"

-- Scrub escape sequences out of pasted text (ANSI colors, OSC 52 clipboard
-- codes) while keeping tab and newline, so multi-line pastes survive intact.
local function scrub(text)
  text = text:gsub("\27%][0-9]*;.-\7", "") -- OSC ... BEL
  text = text:gsub("\27%][0-9]*;.-\27\\", "") -- OSC ... ST
  text = text:gsub("\27%[[0-9;?]*[a-zA-Z]", "") -- CSI (colors, cursor moves)
  text = text:gsub("[%z\1-\8\11-\31\127]", "") -- leftover control chars
  return text
end

local function wl_paste()
  local out = vim.fn.system({ "wl-paste", "--no-newline" })
  if vim.v.shell_error ~= 0 then
    return { "" }
  end
  return vim.split(scrub(out), "\n")
end

vim.g.clipboard = {
  name = "wl-clipboard-no-osc52",
  copy = {
    ["+"] = { "wl-copy" },
    ["*"] = { "wl-copy" },
  },
  paste = {
    ["+"] = wl_paste,
    ["*"] = wl_paste,
  },
  cache_enabled = true,
}

vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
  },
})
