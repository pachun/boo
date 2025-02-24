return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup({
			level = 3,
			render = "minimal",
		})
	end,
}
