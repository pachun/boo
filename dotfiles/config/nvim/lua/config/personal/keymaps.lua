local comment_api = require("Comment.api")
local nvim_tree_api = require("nvim-tree.api")
local telescope_builtin = require("telescope.builtin")
local helpers = require("config.personal.helpers")
local supermaven_api = require("supermaven-nvim.api")
local gitsigns = require("gitsigns")

local keymaps = {
	basic = {
		{
			description = "Exit insert mode with jj",
			mode = "i",
			command = "jj",
			action = "<Esc>",
		},
		{
			description = "Quit shortcut",
			mode = "n",
			command = "<leader>q",
			action = helpers.vim_splits.close_split,
		},
		{
			description = "Save shortcut",
			mode = "n",
			command = "<leader>w",
			action = function()
				vim.cmd("w")
			end,
		},
		{
			description = "Remove highlights (like after searching)",
			mode = "n",
			command = "<leader>nh",
			action = ":nohl<CR>",
		},
		{
			description = "Split window vertically",
			mode = "n",
			command = "<leader>d|",
			action = helpers.vim_splits.vsplit,
		},
		{
			description = "Split window horizontally",
			mode = "n",
			command = "<leader>d_",
			action = helpers.vim_splits.split,
		},
		{
			description = "Toggle split zoom",
			mode = "n",
			command = "<leader>d+",
			action = helpers.vim_splits.toggle_zoom,
		},
		{
			description = "Make splits equally sized",
			mode = "n",
			command = "<leader>de",
			action = "<C-w>=",
		},
		{
			describe = "Move split up/left",
			mode = "n",
			command = "<leader>d{",
			action = "<C-w>r",
		},
		{
			describe = "Move split down/right",
			mode = "n",
			command = "<leader>d}",
			action = "<C-w>R",
		},
		{
			description = "Comment line",
			mode = "n",
			command = "<C-_><C-_>",
			action = function()
				comment_api.toggle.linewise.current()
			end,
		},
		{
			description = "Comment block",
			mode = "v",
			command = "<C-_><C-_>",
			action = function()
				local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
				vim.api.nvim_feedkeys(esc, "x", false)
				comment_api.toggle.linewise(vim.fn.visualmode())
			end,
		},
		{
			description = "Toggle file explorer",
			mode = "n",
			command = "<leader>ee",
			action = function()
				nvim_tree_api.tree.toggle()
			end,
		},
		{
			description = "Toggle file explorer on current file",
			mode = "n",
			command = "<leader>ef",
			action = function()
				nvim_tree_api.tree.toggle({ find_file = true, focus = true })
			end,
		},
		{
			description = "Telescope find files",
			mode = "n",
			command = "<leader>ff",
			action = function()
				telescope_builtin.find_files()
			end,
		},
		{
			description = "Telescope find string",
			mode = "n",
			command = "<leader>fs",
			action = function()
				telescope_builtin.live_grep()
			end,
		},
		{
			description = "Telescope find recent files",
			mode = "n",
			command = "<leader>fr",
			action = function()
				telescope_builtin.oldfiles()
			end,
		},
		{
			description = "Run test under cursor",
			mode = "n",
			command = "<leader>s",
			action = function()
				vim.cmd("TestNearest")
			end,
		},
		{
			description = "Run tests in file",
			mode = "n",
			command = "<leader>t",
			action = function()
				vim.cmd("TestFile")
			end,
		},
		{
			description = "Run all tests",
			mode = "n",
			command = "<leader>a",
			action = function()
				vim.cmd("TestSuite")
			end,
		},
		{
			description = "Toggle git blame",
			mode = "n",
			command = "<leader>gb",
			action = function()
				vim.cmd("BlameToggle")
			end,
		},
		{
			description = "Goto next uncommitted line",
			mode = "n",
			command = "]c",
			action = function()
				local ok = pcall(gitsigns.nav_hunk, "next")
				if not ok then
					vim.cmd("normal! gg")
					gitsigns.nav_hunk("next")
				end
			end,
		},
		{
			description = "Goto previous uncommitted line",
			mode = "n",
			command = "[c",
			action = function()
				local ok = pcall(gitsigns.nav_hunk, "prev")
				if not ok then
					vim.cmd("normal! G")
					gitsigns.nav_hunk("prev")
				end
			end,
		},
		{
			description = "Toggle Supermaven",
			mode = "n",
			command = "<leader>sm",
			action = function()
				if supermaven_api.is_running() then
					supermaven_api.stop()
					print("Supermaven stopped")
				else
					supermaven_api.start()
					print("Supermaven started")
				end
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
				telescope_builtin.lsp_definitions()
			end,
		},
		{
			description = "Show lsp references",
			mode = "n",
			command = "gr",
			action = function()
				telescope_builtin.lsp_references()
			end,
		},
	},
}

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
