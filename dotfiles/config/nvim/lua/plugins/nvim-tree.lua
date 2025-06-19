-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			sort = { sorter = "case_sensitive" },
			view = { width = 40 },
			renderer = {
				group_empty = true,
				-- set the title to be the directory name
				root_folder_label = function(path)
					return vim.fn.fnamemodify(path, ":t")
				end,
			},
			filters = {
				-- hide mimic-generated test files (https://github.com/edgurgel/mimic)
				-- and mac generated dotfiles (.DS_Store)
				custom = { "*.coverdata", ".DS_Store" },
			},
			-- don't show git statuses by files/dirs in nvim-tree
			git = {
				enable = false,
			},
		})
	end,
}
