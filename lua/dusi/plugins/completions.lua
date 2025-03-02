return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependecies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            -- friendly-snippets - enable standardized comments snippets
            require("luasnip").filetype_extend("typescript", { "tsdoc" })
            require("luasnip").filetype_extend("javascript", { "jsdoc" })
            require("luasnip").filetype_extend("lua", { "luadoc" })
            require("luasnip").filetype_extend("python", { "pydoc" })
            require("luasnip").filetype_extend("rust", { "rustdoc" })
            require("luasnip").filetype_extend("cs", { "csharpdoc" })
            require("luasnip").filetype_extend("java", { "javadoc" })
            require("luasnip").filetype_extend("c", { "cdoc" })
            require("luasnip").filetype_extend("cpp", { "cppdoc" })
            require("luasnip").filetype_extend("php", { "phpdoc" })
            require("luasnip").filetype_extend("kotlin", { "kdoc" })
            require("luasnip").filetype_extend("ruby", { "rdoc" })
            require("luasnip").filetype_extend("sh", { "shelldoc" })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        opts = {
            function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0,
                })
            end,
        },
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()
            require("lazydev").setup({
                library = { "nvim-dap-ui" },
            })

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
}
