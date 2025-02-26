return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      top_down = true,
      position = "top-right",    -- Position them in top-right
      max_width = 50,           -- Optional: adjust width
      render = "default",       -- Optional: choose render style
      stages = "fade"          -- Optional: animation style
    })

    -- Set it as the default notify function
    vim.notify = notify
  end
}
