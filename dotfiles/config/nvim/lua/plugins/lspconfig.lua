return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			local language_servers = require("config.pachulski.language_servers")
			local autocmds = require("config.pachulski.autocmds")

			-- install lsps
			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(language_servers) })

			-- set keymaps for all lsps
			autocmds.setup_lsp_keymaps()

			-- configure and attach mason-installed lsps to lspconfig
			for language_server_name, language_server_config in pairs(language_servers) do
				lspconfig[language_server_name].setup(language_server_config)
			end
		end,
	},
}
