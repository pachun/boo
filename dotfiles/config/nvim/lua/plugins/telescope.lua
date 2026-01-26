return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = function(_, path)
					local filename = vim.fn.fnamemodify(path, ":t")
					local parent_directory = vim.fn.fnamemodify(path, ":h:t")
					return parent_directory .. "/" .. filename
				end,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
					},
				},
			},
		})
	end,
}
