return {
	"mfussenegger/nvim-lint",
	dependencies = { "rshkarin/mason-nvim-lint" },
	config = function()
		local mason_nvim_lint = require("mason-nvim-lint")
		local lint = require("lint")

		local helpers = require("config.personal.helpers")
		local linters = require("config.personal.linters")

		mason_nvim_lint.setup({ ensure_installed = vim.tbl_keys(linters) })

		lint.linters_by_ft = helpers.flip_table(linters)
		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
