return { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = { "lua", "c", "c_sharp"},
            highlight = { enable = true },
            indent = { enable = true }
        })


        -- Treesitter csharp setup
        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
        parser_config.csharp = {
            install_info = {
                url = "~/.config/tree-sitter/tree-sitter-c-sharp", -- local path or git repo
                files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
            }
        }

    end
}
