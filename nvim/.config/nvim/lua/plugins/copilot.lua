return {
  'github/copilot.vim',
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = 'claude-3.5-sonnet',
    },
    keys = {
      -- Toggle chat window
      {
        "<leader>cc",
        "<cmd>CopilotChatToggle<cr>",
        desc = "CopilotChat - Toggle chat window",
      },
    },
  },
}
