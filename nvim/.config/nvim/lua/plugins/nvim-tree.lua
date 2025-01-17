return {
  "nvim-tree/nvim-tree.lua",
  enabled = false,
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true
    local api = require("nvim-tree.api")
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      on_attach = function(bufnr)
        local function opts(desc)
          return { buffer = bufnr, desc = desc, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        -- function for left to assign to keybindings
        local lefty = function()
          local node_at_cursor = api.tree.get_node_under_cursor()
          -- if it's a node and it's open, close
          if node_at_cursor.nodes and node_at_cursor.open then
            api.node.open.edit()
            -- else left jumps up to parent
          else
            api.node.navigate.parent()
          end
        end

        -- function for right to assign to keybindings
        local righty = function()
          local node_at_cursor = api.tree.get_node_under_cursor()
          -- if it's a closed node, open it
          if node_at_cursor.nodes and not node_at_cursor.open then
            api.node.open.edit()
          end
        end

        -- Your existing navigation mappings
        vim.keymap.set("n", "h", lefty, opts("Navigate left"))
        vim.keymap.set("n", "<Left>", lefty, opts("Navigate left"))
        vim.keymap.set("n", "<Right>", righty, opts("Navigate right"))
        vim.keymap.set("n", "l", righty, opts("Navigate right"))

        -- Add split mappings
        vim.keymap.set("n", "<S-CR>", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
      end,
    })
    local keymap = vim.keymap
    keymap.set("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer"})
  end
}
