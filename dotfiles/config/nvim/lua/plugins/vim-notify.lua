return {
	"rcarriga/nvim-notify",
	config = function()
		require("notify").setup({
			level = 2,
		})
	end,
}
