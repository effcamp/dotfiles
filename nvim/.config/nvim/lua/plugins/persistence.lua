return {
  'folke/persistence.nvim',
  event = "VimEnter",
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize" },
  },
  config = function(_, opts)
    require("persistence").setup(opts)
    
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("persistence_load", { clear = true }),
      callback = function()
        -- Allow both `nvim` and `nvim .` to trigger session loading
        if vim.fn.argc() <= 1 and (vim.fn.argc() == 0 or vim.fn.argv(0) == '.') then
          vim.defer_fn(function()
            require("persistence").load()
          end, 100)
        end
      end,
    })
  end
}
