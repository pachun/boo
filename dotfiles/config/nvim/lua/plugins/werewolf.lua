local theme = require("config.pachulski.theme")

return {
	"sheharyarn/werewolf.nvim",
	opts = {
		system_theme = {
			on_change = function(theme_type)
				if theme_type == "Dark" then
					vim.o.background = theme.dark.style
					vim.cmd.colorscheme(theme.dark.name)
				else
					vim.o.background = theme.light.style
					vim.cmd.colorscheme(theme.light.name)
				end
			end,
		},
	},
}
