-- Copilot-only plugin spec (no cmp integration)
--
-- Two kinds of suggestion, both shown in green so it is obvious what Copilot
-- wants to change before anything is applied:
--   * inline ghost text  -- what it would insert at the cursor
--   * nes ("next edit suggestion") -- a diff of an edit to code you already
--     wrote, rendered with the usual added/removed diff highlights
local green = "#6CC644" -- GitHub's Copilot green

local function set_copilot_hl()
  -- copilot.lua only links CopilotSuggestion->Comment when the group is still
  -- empty, so defining it here wins -- but a colorscheme load clears it, hence
  -- the ColorScheme autocmd below.
  vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = green, italic = true })
  vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = green, italic = true })
end

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    dependencies = { "copilotlsp-nvim/copilot-lsp" }, -- provides nes
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-]>",
            accept_word = "<M-w>",
            accept_line = "<M-j>",
            next = "<M-]>",
            prev = "<M-[>",
            -- upstream defaults dismiss to <C-]> too, which collides with
            -- accept above and makes one key mean both things
            dismiss = "<M-\\>",
          },
        },
        -- Next edit suggestions: Copilot proposes a change to existing code and
        -- shows it as a diff; <Tab> applies it, <Esc> throws it away. Both are
        -- passthrough, so they behave normally when no suggestion is pending.
        nes = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept_and_goto = "<Tab>",
            accept = false,
            dismiss = "<Esc>",
          },
        },
        panel = { enabled = true },
        filetypes = {
          -- enable Copilot for common programming filetypes
          python = true,
          javascript = true,
          typescript = true,
          lua = true,
          rust = true,
        },
      })
      set_copilot_hl()
    end,
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("copilot_green_hl", { clear = true }),
        callback = set_copilot_hl,
      })
    end,
  },
}
