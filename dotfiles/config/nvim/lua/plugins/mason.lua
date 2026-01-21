-- Each plugin (lspconfig, conform, nvim-lint) installs its own Mason tools via ensure_installed.
-- This file aggregates all tools for headless pre-installation via MasonToolsInstallSync in install.sh,
-- so nvim is ready to use immediately after OS setup.
return {
	"williamboman/mason.nvim",
	dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
	config = function()
		require("mason").setup()

		local language_servers = require("config.personal.language_servers")
		local formatters = require("config.personal.formatters")
		local linters = require("config.personal.linters")

		local all_tools = {}
		vim.list_extend(all_tools, vim.tbl_keys(language_servers))
		vim.list_extend(all_tools, vim.tbl_keys(formatters))
		vim.list_extend(all_tools, vim.tbl_keys(linters))

		require("mason-tool-installer").setup({
			ensure_installed = all_tools,
		})
	end,
}
