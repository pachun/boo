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

			local language_servers = require("config.personal.language_servers")
			local autocmds = require("config.personal.autocmds")

			-- install lsps
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(language_servers),

				-- mason_lspconfig automatically enables installed servers, by default;
				-- we do that below, with custom configs, so we prevent mason from
				-- automatically doing that with default configs here. Otherwise, multiple
				-- instances of each lsp (one that mason starts with a default config,
				-- and one that we set up below with a custom config) attach to buffers.
				automatic_enable = false,
			})

			-- set keymaps for all lsps
			autocmds.setup_lsp_keymaps()

			-- configure and attach mason-installed lsps to lspconfig
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local config_for_all_lsps = {
				capabilities = cmp_nvim_lsp.default_capabilities(),
			}

			for language_server_name, language_server_config in pairs(language_servers) do
				vim.lsp.config[language_server_name] = vim.tbl_extend("force", config_for_all_lsps, language_server_config)
				vim.lsp.enable(language_server_name)
			end
		end,
	},
}
