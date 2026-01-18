return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			local theme = require("config.personal.theme")
			vim.o.background = theme.dark.style
			vim.cmd.colorscheme(theme.dark.name)
		end,
	},
}
