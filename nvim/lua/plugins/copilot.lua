-- Copilot-only plugin spec (no cmp integration)
return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-]>",
            accept_word = false,
            accept_line = false,
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
    end,
  },
}
