local formatters = {
	prettier = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescript_react",
		"css",
		"html",
		"json",
		"yaml",
		"markdown",
	},
	stylua = { "lua" },
}

return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(formatters) })

			local formatters_by_ft = function(f)
				local formatted_map = {}
				for formatter, languages in pairs(f) do
					for _, language in ipairs(languages) do
						formatted_map[language] = { formatter }
					end
				end
				return formatted_map
			end

			require("conform").setup({
				formatters_by_ft = formatters_by_ft(formatters),
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
