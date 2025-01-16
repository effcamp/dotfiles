-- More aggressive autosave (also on TextChanged and InsertLeave)
-- vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
--   pattern = { "*.txt", "*.lua", "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.scss", "*.md" },
--   callback = function()
--     if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
--       vim.api.nvim_command('silent! write')
--     end
--   end,
-- })

-- Ignore certain filetypes
-- local ignored_filetypes = {
--   "neo-tree",
--   "TelescopePrompt",
--   "lazy",
--   "mason",
--   "harpoon",
--   "gitcommit",
--   "NeogitCommitMessage",
-- }
--
-- vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
--   callback = function()
--     if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
--       return
--     end
--     if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
--       vim.api.nvim_command('silent! write')
--     end
--   end,
-- })
local autosave_enabled = true

vim.api.nvim_create_user_command('ToggleAutosave', function()
  autosave_enabled = not autosave_enabled
  print("Autosave " .. (autosave_enabled and "enabled" or "disabled"))
end, {})
-- test comment
-- Then modify the callback to check the flag
callback = function()
  if not autosave_enabled then return end
  -- rest of the autosave logic
  -- Basic autosave for most files
  vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufLeave", "FocusLost" }, {
    callback = function()
      if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
        vim.api.nvim_command('silent! write')
      end
    end,
  })

end
