return {
	"numToStr/Comment.nvim",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	config = function()
		local comment = require("Comment")
		local ts_context_comment_integration = require("ts_context_commentstring.integrations.comment_nvim")
		comment.setup({ pre_hook = ts_context_comment_integration.create_pre_hook() })
	end,
}
