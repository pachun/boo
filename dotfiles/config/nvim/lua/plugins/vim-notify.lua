return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup({
			level = 2,
			render = "minimal",
			max_width = 70,
		})
	end,
}
