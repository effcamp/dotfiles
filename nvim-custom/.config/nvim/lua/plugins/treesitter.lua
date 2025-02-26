return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'lua', 'vim', 'vimdoc', 'query' },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                -- Add incremental selection configuration
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = false, -- disable init_selection
                        node_incremental = '<CR>',
                        node_decremental = '<bs>',
                        scope_incremental = false, -- disable scope_incremental
                    },
                },
            }
        end
    }
}
