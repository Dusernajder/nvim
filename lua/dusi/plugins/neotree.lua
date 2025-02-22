return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.keymap.set('n', '<C-n>',
            function()
                local neotree = require("neo-tree.command")
                neotree.execute({ toggle = true, source = "filesystem", position = "left" })
            end,
            { noremap = true, silent = true }
        )

        -- Auto close Neo-tree when opening a file
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname ~= "" and not string.match(bufname, "neo%-tree filesystem") then
                    require("neo-tree.command").execute({ action = "close" })
                end
            end
        })
    end
}
