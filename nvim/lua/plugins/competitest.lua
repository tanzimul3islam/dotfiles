return {
  {
    "xeluxee/competitest.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      floating_border = "rounded",
      runner_ui = {
        interface = "split",
        show_nu = false,
        show_rnu = false,
        selector_show_nu = false,
        selector_show_rnu = false,
        mappings = {
          close = { "q", "Q" },
        },
      },
      split_ui = {
        position = "right",
        relative_to_editor = true,
        total_width = 0.3,
        vertical_layout = {
          { 1, "tc" },
          { 1, { { 1, "so" }, { 1, "eo" } } },
          { 1, { { 1, "si" }, { 1, "se" } } },
        },
      },

      run_command = {
        python = { exec = "python3", args = { "$(FNAME)" } },
      },
      save_current_file = true,
      maximum_time = 5000,
      output_compare_method = "squish",
      testcases_use_single_file = false,
      testcases_auto_detect_storage = true,
    },
  },
}
