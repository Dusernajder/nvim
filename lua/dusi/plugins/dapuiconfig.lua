return {
	"rcarriga/nvim-dap-ui",
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "r",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			element_mappings = {
				-- stacks = {
				--     open = "<CR>",
				--     expand = "o",
				-- }
			},
			expand_lines = vim.fn.has("nvim-0.7") == 1,
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						"breakpoints",
						"stacks",
						"watches",
					},
					size = 40, -- 40 columns
					position = "left",
				},
				{
					elements = {
						"repl",
						"console",
					},
					size = 0.25, -- 25% of total lines
					position = "bottom",
				},
			},
			controls = {
				enabled = true,
				-- Display controls in this element
				element = "repl",
				icons = {
					disconnect = "✖",
					pause = "‖",
					play = "▶",
					run_last = "↻",
					step_back = "⏮",
					step_into = "↘",
					step_out = "↗",
					step_over = "⏭",
					terminate = "■",
				},
			},
			floating = {
				max_height = nil,
				max_width = nil,
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
			render = {
				max_type_length = nil,
				max_value_lines = 100,
			},
			force_buffers = true,
		})

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.after.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.after.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}
