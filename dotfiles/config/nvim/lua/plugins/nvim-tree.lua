-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
			},
			renderer = {
				group_empty = true,

				-- set the title to be the directory name
				root_folder_label = function(path)
					return vim.fn.fnamemodify(path, ":t")
				end,
			},
			filters = {
				-- hide mimic-generated test files (https://github.com/edgurgel/mimic)
				custom = { "*.coverdata", ".DS_Store" },
			},
		})

		vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

		vim.keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		)
	end,
}
