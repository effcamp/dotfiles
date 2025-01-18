vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>w", ":wall<CR>", { desc = "Save All with leader w"})
keymap.set("n", "<C-q><C-q>", ":wqa<CR>", { desc = "Save all and quit vim with Ctrl+Q"})
-- keymap.set("n", "<leader>e", ":Ex<CR>", { desc = "Open Explorer"})
keymap.set("n", "K", "i<CR><ESC>==", { desc = "Split lines and indent"})
vim.keymap.set("n", "<leader>fp", ":%s/\\s*\\r\\|\\s\\+$//g<CR>", { desc = "Format pasted text from windows" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight when ESC after search" })

vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking replaced text" })
keymap.set("n", "<PageUp>", "<c-u>", { desc = "Half page up", noremap = true, })
keymap.set("n", "<PageDown>", "<c-d>", { desc = "Half page down", noremap = true, })
-- Page up/down
keymap.set('i', '<PageUp>', '<Esc><C-u>', { desc = 'Exit insert and page up', noremap = true })
keymap.set('i', '<PageDown>', '<Esc><C-d>', { desc = 'Exit insert and page down', noremap = true })
-- Arrow keys
keymap.set('i', '<Up>', '<Esc><Up>', { desc = 'Exit insert and move up' })
keymap.set('i', '<Down>', '<Esc><Down>', { desc = 'Exit insert and move down' })

-- Home/End keys in normal and visual modes
vim.keymap.set({'n', 'v'}, '<Home>', '^', { desc = 'Go to first non-blank character' })
vim.keymap.set({'n', 'v'}, '<End>', '$', { desc = 'Go to end of line' })

-- Ctrl+Left/Right in normal and visual modes
vim.keymap.set({'n', 'v'}, '<C-Left>', 'b', { desc = 'Move back one word' })
vim.keymap.set({'n', 'v'}, '<C-Right>', 'w', { desc = 'Move forward one word' })

-- Arrow and Page up/down
vim.keymap.set('i', '<PageUp>', '<Cmd>normal! <C-u><CR>', { desc = 'Exit insert and page up' })
vim.keymap.set('i', '<PageDown>', '<Cmd>normal! <C-d><CR>', { desc = 'Exit insert and page down' })

-- Home/End
vim.keymap.set('i', '<Home>', '<Cmd>normal! ^a<CR>', { desc = 'Go to first non-blank character' })

-- Move line or selected block up and down with ALT+Up / ALT+Down
keymap.set('n', '<M-Up>', ":m .-2<CR>==", { noremap = true, silent = true })
keymap.set('n', '<M-Down>', ":m .+1<CR>==", { noremap = true, silent = true })
keymap.set('v', '<M-Up>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
keymap.set('v', '<M-Down>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set('i', '<M-Up>', "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
keymap.set('i', '<M-Down>', "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })

-- Reselect visual selection after indenting
keymap.set('v', '<', '<gv', { noremap = true, silent = true })
keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Map for normal, insert, and visual modes using a table of modes
keymap.set({'n', 'i', 'v'}, '<C-PageUp>', '<ESC>:bprevious<CR>', { silent = true })
keymap.set({'n', 'i', 'v'}, '<C-PageDown>', '<ESC>:bnext<CR>', { silent = true })

keymap.set('n', '<leader>va', 'ggVG', { noremap = true, desc = 'Select all text' })

-- Direction aware approach yanking
keymap.set('v', 'y', function()
    -- Store cursor position before yanking
    local cursor_line = vim.fn.line('.')
    local visual_line = vim.fn.line('v')

    -- Return the yank command with the appropriate jump
    if cursor_line < visual_line then
        return 'y`['  -- Jump to start of yanked text
    else
        return 'y`]'  -- Jump to end of yanked text
    end
end, { noremap = true, expr = true })

vim.keymap.set('n', '<C-f>', '<cmd>lua print("disabled")<CR>', { noremap = true })
vim.keymap.set('v', '<C-f>', '<cmd>lua print("disabled")<CR>', { noremap = true })
vim.keymap.set('i', '<C-f>', '<cmd>lua print("disabled")<CR>', { noremap = true })

vim.keymap.set('n', '<C-b>', '<cmd>lua print("disabled")<CR>', { noremap = true })
vim.keymap.set('v', '<C-b>', '<cmd>lua print("disabled")<CR>', { noremap = true })
vim.keymap.set('i', '<C-b>', '<cmd>lua print("disabled")<CR>', { noremap = true })

-- Ctrl + Alt combinations for horizontal resize
vim.keymap.set('n', '<C-M-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-M-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- Up/Down for vertical resize
vim.keymap.set('n', '<C-M-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-M-Down>', ':resize -2<CR>', { noremap = true, silent = true })

-- Store original window sizes
local original_sizes = {}
local is_maximized = false

local function toggle_maximize_split()
    if not is_maximized then
        -- Store current window sizes before maximizing
        original_sizes = {}
        for _, win in pairs(vim.api.nvim_list_wins()) do
            original_sizes[win] = {
                width = vim.api.nvim_win_get_width(win),
                height = vim.api.nvim_win_get_height(win)
            }
        end

        -- Maximize current window
        vim.cmd('resize')
        vim.cmd('vertical resize')
        is_maximized = true
    else
        -- Restore original sizes
        for win, size in pairs(original_sizes) do
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_width(win, size.width)
                vim.api.nvim_win_set_height(win, size.height)
            end
        end
        is_maximized = false
        -- Clear stored sizes
        original_sizes = {}
    end
end

-- Map Ctrl+Alt+m to toggle maximize
vim.keymap.set('n', '<C-M-m>', toggle_maximize_split, { noremap = true, silent = true })
