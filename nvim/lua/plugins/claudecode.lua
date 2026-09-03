-- Claude Code integration: runs the claude CLI in a terminal split and talks to
-- it over the same MCP/WebSocket protocol the official IDE extensions use, so
-- Claude sees the current file/selection and diffs land in nvim buffers.
local claude_commands = {
  -- Core commands
  "ClaudeCode",
  "ClaudeCodeFocus",
  "ClaudeCodeSend",
  "ClaudeCodeAdd",
  "ClaudeCodeTreeAdd",
  "ClaudeCodeSelectModel",
  -- Diff review
  "ClaudeCodeDiffAccept",
  "ClaudeCodeDiffDeny",
  -- Status and diagnostics
  "ClaudeCodeStatus",
  "ClaudeCodeClients",
  -- Custom commands (added in config)
  "ClaudeCodeCheck",
  "ClaudeCodeQuick",
}

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = claude_commands,
    config = function(_, opts)
      require("claudecode").setup(opts)
      local logger = require("claudecode.logger")
      local orig_error = logger.error

      logger.error = function(component, ...)
        local msg = table.concat(vim.tbl_map(tostring, { ... }), " ")
        if component == "server" and msg:find("Client read error", 1, true) then
          vim.schedule(function()
            vim.api.nvim_echo({ { "[ClaudeCode] " .. msg, "WarningMsg" } }, true, {})
          end)
          return
        end
        return orig_error(component, ...)
      end

      local server_module = require("claudecode.server.init")

      vim.api.nvim_create_user_command("ClaudeCodeClients", function()
        local server = server_module.state.server
        if not server then
          vim.notify("ClaudeCode: server not running (:ClaudeCode to start)", vim.log.levels.WARN)
          return
        end
        local ids = vim.tbl_keys(server.clients or {})
        if #ids == 0 then
          vim.notify(
            "ClaudeCode: 0 clients on port "
              .. tostring(server_module.state.port)
              .. "\nRun Claude with :ClaudeCode, or in an external terminal use"
              .. " `claude --ide` / the /ide command to attach.",
            vim.log.levels.WARN
          )
        else
          vim.notify("ClaudeCode: " .. #ids .. " client(s) attached -- diffs will open here", vim.log.levels.INFO)
        end
      end, { desc = "Show Claude CLI clients attached to this Neovim" })

      -- Check connection status with detailed info
      vim.api.nvim_create_user_command("ClaudeCodeCheck", function()
        local server = server_module.state.server
        local port = server_module.state.port
        if not server then
          vim.notify("❌ ClaudeCode server not running\n\nStart with :ClaudeCode", vim.log.levels.ERROR)
          return
        end
        local clients = vim.tbl_keys(server.clients or {})
        if #clients == 0 then
          vim.notify(
            "⚠️  ClaudeCode server running on port " .. port .. " but 0 clients attached\n\n"
              .. "Attach Claude CLI with :ClaudeCode or `claude --ide` in another terminal",
            vim.log.levels.WARN
          )
        else
          vim.notify("✓ ClaudeCode ready (" .. #clients .. " client" .. (#clients > 1 and "s" or "") .. ")", vim.log.levels.INFO)
        end
      end, { desc = "Check Claude Code connection status" })

      -- Quick send current buffer content (useful for quick asks)
      vim.api.nvim_create_user_command("ClaudeCodeQuick", function(opts)
        local args = vim.fn.split(opts.args, " ", true)
        local query = table.concat(args, " ")
        if query == "" then
          query = vim.fn.input("Quick question for Claude: ")
        end
        if query ~= "" then
          vim.cmd("ClaudeCodeFocus")
          vim.cmd("ClaudeCodeSend")
        end
      end, { desc = "Quick send to Claude", nargs = "*" })
    end,
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
      },
      diff_opts = {
        layout = "unified",
        keep_terminal_focus = false,
        open_in_new_tab = false,
      },
    },
    keys = {
      -- Leader prefix group
      { "<leader>a", nil, desc = "AI/Claude Code" },

      -- Core operations
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },

      -- Session management
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },

      -- File and content operations
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file from tree",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },

      -- Model and settings
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },

      -- Status and diagnostics
      { "<leader>a?", "<cmd>ClaudeCodeCheck<cr>", desc = "Check status" },
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Show port" },
      { "<leader>aL", "<cmd>ClaudeCodeClients<cr>", desc = "List clients" },

      -- Diff review
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
