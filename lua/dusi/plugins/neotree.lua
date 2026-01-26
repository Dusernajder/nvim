return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        local neo_tree = require("neo-tree")

        -- Set highlight colors BEFORE setup
        vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e5c07b", bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#98c379", bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#e06c75", bold = true })

        neo_tree.setup({
            popup_border_style = "rounded",
            visible = true,
            hide_dotfiles = false,
            hide_hidden = false,
            enable_git_status = true,
            use_git_status_colors = true,
            git_status = {
                highlight_modified = "NeoTreeGitModified",
                highlight_added = "NeoTreeGitAdded",
                highlight_deleted = "NeoTreeGitDeleted",
            },
            enable_diagnostics = true,
            window = {
                position = "left",
                width = 40,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    ["<space>"] = { "toggle_node", nowait = true },
                    ["<2-LeftMouse>"] = "open",
                    ["<cr>"] = { "open", config = { close = true } },
                    ["<esc>"] = "cancel",
                    ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                    ["l"] = "focus_preview",
                    ["S"] = "open_split",
                    ["s"] = "open_vsplit",
                    ["t"] = "open_tabnew",
                    ["C"] = "close_node",
                    ["H"] = "toggle_hidden",
                    ["z"] = "close_all_nodes",
                    ["a"] = {
                        "add",
                        config = { show_path = "none" },
                    },
                },
            },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                use_libuv_file_watcher = true,
            },
        })

        -- Reapply colors after colorscheme changes
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e5c07b", bold = true })
                vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#98c379", bold = true })
                vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#e06c75", bold = true })
            end,
        })

        -- Toggle/focus Neo-tree with cursor on current file
        vim.keymap.set("n", "<C-n>", function()
            require("neo-tree.command").execute({
                toggle = true,
                source = "filesystem",
                position = "left",
                reveal = true,
                focus = true,
            })
        end, { noremap = true, silent = true })

        -- Auto close Neo-tree when opening a file
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                local bufname = vim.api.nvim_buf_get_name(0)
                if bufname ~= "" and not string.match(bufname, "neo%-tree filesystem") then
                    require("neo-tree.command").execute({ action = "close" })
                end
            end,
        })
    end,
}
