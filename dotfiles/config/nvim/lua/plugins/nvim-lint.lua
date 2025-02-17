local linters = {
	eslint_d = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescript_react",
	},
}

return {
	"mfussenegger/nvim-lint",
	dependencies = { "rshkarin/mason-nvim-lint" },
	config = function()
		require("mason-nvim-lint").setup({
			ensure_installed = vim.tbl_keys(linters),
		})

		local linters_by_ft = function(f)
			local formatted_map = {}
			for linter, filetype in pairs(f) do
				for _, language in ipairs(filetype) do
					formatted_map[language] = { linter }
				end
			end
			return formatted_map
		end

		require("lint").linters_by_ft = linters_by_ft(linters)
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
