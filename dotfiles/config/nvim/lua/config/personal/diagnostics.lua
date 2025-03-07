local function setup()
	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local icons = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "󰠠",
				}
				return string.format(
					"%s %s [%s %s]",
					icons[diagnostic.severity],
					diagnostic.message,
					diagnostic.source,
					diagnostic.code
				)
			end,

			-- hide default block icon by diagnostics
			prefix = "",
		},

		-- remove gutter signs
		signs = false,

		-- don't update lsp diagnostics while typing
		update_in_insert = false,

		-- don't underline errors
		underline = false,

		-- make floating diagnostics look a little nicer
		float = {
			header = "",
			border = "rounded",
		},
	})
end

return {
	setup = setup,
}
