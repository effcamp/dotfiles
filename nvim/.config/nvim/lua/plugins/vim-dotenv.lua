return {
  "tpope/vim-dotenv",
  lazy = false,
  config = function()
    vim.cmd("Dotenv ~/.config/nvim/.env")
  end,
}
