return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
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

		-- Python
		require("mason-nvim-dap").setup({
			ensure_installed = { "python" },
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",

				-- Make sure the debuggee runs in the venv
				pythonPath = function()
					local cwd = vim.fn.getcwd()
					local venv = cwd .. "/.venv/bin/python"
					if vim.fn.executable(venv) == 1 then
						return venv
					end
					return vim.fn.exepath("python") -- fallback
				end,

				-- important for stepping/subprocesses
				justMyCode = false,
				subProcess = true,
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
