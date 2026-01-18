return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local syntax_highlighters = require("config.personal.syntax_highlighters")

		require("nvim-treesitter").setup({
			ensure_installed = syntax_highlighters,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
