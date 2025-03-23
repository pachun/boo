return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local treesitter_config = require("nvim-treesitter.configs")
		local syntax_highlighters = require("config.personal.syntax_highlighters")

		treesitter_config.setup({
			highlight = { enable = true },
			indent = { enable = true, disable = { "ruby" } },
			incremental_selection = { enable = true },
			autotag = { enable = true },
			ensure_installed = syntax_highlighters,
		})
	end,
}
