return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"rcarriga/cmp-dap",
		"jay-babu/mason-nvim-dap.nvim",
		"jbyuki/one-small-step-for-vimkind",
		"nvim-java/nvim-java",
		"nvim-neotest/nvim-nio",
		{
			"Cliffback/netcoredbg-macOS-arm64.nvim",
			dependencies = { "mfussenegger/nvim-dap" },
		},
		"julianolf/nvim-dap-lldb",
	},
	enabled = vim.fn.has("win32") == 0,
	event = "User BaseFile",
	config = function()
		local dap = require("dap")

		-- C#
		require("netcoredbg-macOS-arm64").setup(require("dap"))

		-- C
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.c = {
			{
				name = "c",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				--program = '${fileDirname}/${fileBasenameNoExtension}',
				cwd = "${workspaceFolder}",
				terminal = "integrated",
			},
		}

		vim.keymap.set("n", "<Leader>b", function()
			dap.toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>cb", function()
			vim.ui.input({ prompt = "Enter condition: " }, function(condition)
				if condition then
					dap.set_breakpoint(condition)
				end
			end)
		end)
		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end)
		vim.keymap.set("n", "<F12>", function()
            dap.terminate()
		end)
		vim.keymap.set("n", "<F6>", function()
			dap.step_over()
		end)
		vim.keymap.set("n", "<F7>", function()
			dap.step_into()
		end)
		vim.keymap.set("n", "<F8>", function()
			dap.step_out()
		end)

		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "🛑", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "🔵", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "⚠️", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
		)
		vim.fn.sign_define(
			"DapLogPoint",
			{ text = "📍", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "▶️", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
		)
	end,
}
