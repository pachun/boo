return {
	"sheharyarn/werewolf.nvim",
	opts = {
		system_theme = {
			on_change = function(theme)
				if theme == "Dark" then
					vim.cmd.colorscheme("catppuccin-frappe")
				else
					vim.cmd.colorscheme("catppuccin-latte")
				end
			end,
		},
	},
}
