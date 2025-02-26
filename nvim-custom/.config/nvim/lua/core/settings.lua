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
    local buffer_count = #vim.fn.getbufinfo({buflisted = 1})

    if buffer_count > 1 then
        -- With multiple buffers, delete current buffer with save check
        vim.cmd('bw')  -- 'bw' is equivalent to :bw or :bdelete!
    else
        -- With single buffer, quit
        vim.cmd('q')
    end
end

-- Unmap default first

-- Set new mappings
vim.keymap.set('n', '<C-w><C-q>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<C-s>q', '<Nop>', { noremap = true })
vim.keymap.set('n', '<C-w>q', close_window_or_buffer, { noremap = true, silent = true })
vim.keymap.set('n', '<C-w><C-q>', close_window_or_buffer, { noremap = true, silent = true })
