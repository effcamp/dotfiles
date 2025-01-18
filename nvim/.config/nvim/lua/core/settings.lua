-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
local function close_window_or_buffer()
    -- Get count of windows
    local win_count = #vim.api.nvim_list_wins()

    if win_count > 1 then
        -- If there are splits, just close the window
        vim.cmd('quit')
    else
        -- If no splits, delete the buffer
        vim.cmd('bd')
    end
end

vim.keymap.set('n', '<C-w>q', close_window_or_buffer, { noremap = true, silent = true })
vim.keymap.set('n', '<C-w><C-q>', close_window_or_buffer, { noremap = true, silent = true })
