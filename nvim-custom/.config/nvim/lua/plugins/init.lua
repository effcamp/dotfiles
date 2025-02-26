return {
  "tpope/vim-sleuth",
  "nvim-lua/plenary.nvim",
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  }
}
