return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = {
          preset = "vertical",
        },
        layouts = {
          vertical = {
            layout = {
              backdrop = false,
              width = 0.8,
              min_width = 80,
              height = 0.8,
              min_height = 30,
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", height = 0.2, border = "none" },
              { win = "preview", title = "{preview}", border = "top" },
            },
          },
        },
        sources = {
          files = {
            hidden = true,
          },
        },
        matcher = {
          frecency = true,
        },
        win = {
          input = {
            keys = {
              ["<PageUp>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<PageDown>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>fR", LazyVim.pick("oldfiles"), desc = "Recent" },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent({ filter = { cwd = true } })
        end,
        desc = "Recent (cwd)",
      },
    },
  },
}
