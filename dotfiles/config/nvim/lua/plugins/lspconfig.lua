return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			local language_servers = require("config.personal.language_servers")
			local autocmds = require("config.personal.autocmds")

			-- install lsps
			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(language_servers) })

			-- set keymaps for all lsps
			autocmds.setup_lsp_keymaps()

			-- configure and attach mason-installed lsps to lspconfig
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local config_for_all_lsps = {
				capabilities = cmp_nvim_lsp.default_capabilities(),
			}

			for language_server_name, language_server_config in pairs(language_servers) do
				lspconfig[language_server_name].setup(
					vim.tbl_extend("force", config_for_all_lsps, language_server_config)
				)
			end
		end,
	},
}
