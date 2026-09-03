-- LazyVim wires the o/f/c textobjects to treesitter queries. A language with no
-- textobjects.scm makes those specs raise E5108 instead of simply not matching --
-- markdown_inline is injected into every markdown file and has no such query, so
-- af/if/ac/ao anywhere in inline markdown throws a stack trace.
-- Degrade a missing query to "no textobject found".
return {
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      for _, key in ipairs({ "o", "f", "c" }) do
        local spec = opts.custom_textobjects and opts.custom_textobjects[key]
        if type(spec) == "function" then
          opts.custom_textobjects[key] = function(...)
            local ok, res = pcall(spec, ...)
            return ok and res or {}
          end
        end
      end
      return opts
    end,
  },
}
