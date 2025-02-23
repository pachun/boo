local keymaps = {
	basic = {
		{
			description = "Exit insert mode with jj",
			mode = "i",
			command = "jj",
			action = "<Esc>",
		},
		{
			description = "Save with :w or :W",
			mode = "c",
			command = "W",
			action = "w",
		},
		{
			description = "Quote with :q or :Q",
			mode = "c",
			command = "Q",
			action = "q",
		},
		{
			description = "Remove highlights (like after searching)",
			mode = "n",
			command = "<leader>rh",
			action = ":nohl<CR>",
		},
		{
			description = "Split window vertically",
			mode = "n",
			command = "<leader>d|",
			action = "<C-w>v",
		},
		{
			description = "Split window horizontally",
			mode = "n",
			command = "<leader>d_",
			action = "<C-w>s",
		},
		{
			description = "Maximize split",
			mode = "n",
			command = "<leader>d+",
			action = function()
				local session_file = "/tmp/vim_session_" .. vim.fn.getpid() .. ".vim"
				if vim.fn.filereadable(session_file) == 1 then
					vim.cmd("silent! source " .. session_file)
					vim.fn.delete(session_file)
				else
					vim.cmd("mks! " .. session_file)
					vim.cmd("wincmd o")
				end
			end,
		},
		{
			description = "Comment line",
			mode = "n",
			command = "<C-_><C-_>",
			action = function()
				require("Comment.api").toggle.linewise.current()
			end,
		},
		{
			description = "Comment block",
			mode = "v",
			command = "<C-_><C-_>",
			action = function()
				local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
				vim.api.nvim_feedkeys(esc, "x", false)
				require("Comment.api").toggle.linewise(vim.fn.visualmode())
			end,
		},
		{
			description = "Toggle file explorer",
			mode = "n",
			command = "<leader>ee",
			action = function()
				require("nvim-tree.api").tree.toggle()
			end,
		},
		{
			description = "Toggle file explorer on current file",
			mode = "n",
			command = "<leader>ef",
			action = function()
				require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
			end,
		},
		{
			description = "Telescope find files",
			mode = "n",
			command = "<leader>ff",
			action = function()
				require("telescope.builtin").find_files()
			end,
		},
		{
			description = "Telescope find string",
			mode = "n",
			command = "<leader>fs",
			action = function()
				require("telescope.builtin").livegrep()
			end,
		},
		{
			description = "Telescope find recent files",
			mode = "n",
			command = "<leader>fr",
			action = function()
				require("telescope.builtin").oldfiles()
			end,
		},
		{
			description = "Run test under cursor",
			mode = "n",
			command = "<leader>s",
			action = function()
				require("config.pachulski.helpers").run_test_in_another_tmux_pane("nearest")
			end,
		},
		{
			description = "Run tests in file",
			mode = "n",
			command = "<leader>t",
			action = function()
				require("config.pachulski.helpers").run_test_in_another_tmux_pane("file")
			end,
		},
		{
			description = "Run all tests",
			mode = "n",
			command = "<leader>a",
			action = function()
				require("config.pachulski.helpers").run_test_in_another_tmux_pane("all")
			end,
		},
	},
	lsp = {
		{
			description = "Show line diagnostics",
			mode = "n",
			command = "<leader>d",
			action = vim.diagnostic.open_float,
		},
		{
			description = "Smart rename",
			mode = "n",
			command = "<leader>rn",
			action = vim.lsp.buf.rename,
		},
		{
			description = "Jump to previous diagnostic",
			mode = "n",
			command = "[d",
			action = vim.diagnostic.goto_prev,
		},
		{
			description = "Jump to next diagnostic",
			mode = "n",
			command = "]d",
			action = vim.diagnostic.goto_next,
		},
		{
			description = "Show lsp definitions",
			mode = "n",
			command = "gd",
			action = function()
				require("telescope.builtin").lsp_definitions()
			end,
		},
		{
			description = "Show lsp references",
			mode = "n",
			command = "gr",
			action = function()
				require("telescope.builtin").lsp_references()
			end,
		},
	},
}

local helpers = require("config.pachulski.helpers")

return {
	setup = function()
		for _, keymap in ipairs(keymaps.basic) do
			helpers.setup_keymap(keymap)
		end
	end,

	setup_lsp_keymaps = function(event)
		for _, lsp_keymap in ipairs(keymaps.lsp) do
			helpers.setup_keymap(lsp_keymap, { buffer = event.buf })
		end
	end,
}
