return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
        check_ts = true, -- Enable treesitter
        ts_config = {
            javascript = { "string" }, -- Don't add pairs in javascript quotes
            typescript = { "string", "template_string" },
            -- other languages ...
        },
    },
}
