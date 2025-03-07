return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local conform = require("conform")
			local mason_tool_installer = require("mason-tool-installer")

			local helpers = require("config.personal.helpers")
			local formatters = require("config.personal.formatters")

			mason_tool_installer.setup({
				ensure_installed = vim.tbl_keys(formatters),
			})

			conform.setup({
				formatters_by_ft = helpers.flip_table(formatters),
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
