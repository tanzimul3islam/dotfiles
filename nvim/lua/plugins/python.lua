-- Python LSP tuning. Requires the `lang.python` LazyVim extra (:LazyExtras),
-- which installs basedpyright + ruff via Mason. basedpyright is what answers
-- textDocument/references, so `grr` depends on it; ruff does not implement it.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            python = {
              -- No project venv; fall back to the conda interpreter that
              -- actually has torch/numpy/sklearn installed.
              pythonPath = vim.fn.executable(".venv/bin/python") == 1 and ".venv/bin/python"
                or vim.fn.expand(
                  "~/.x-cmd.root/local/data/pkg/sphere/X/tree.linux.x64.0/miniconda/v3.10.0+23.9.0-0/bin/python3"
                ),
            },
            basedpyright = {
              analysis = {
                -- `recommended` (the default) buries this terse, untyped
                -- codebase in diagnostics; navigation works the same either way.
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },
}
