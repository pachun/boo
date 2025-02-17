local language_server_configs_by_name = {
	ts_ls = {},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" }, -- Prevent "undefined global 'vim'" warning
				},
			},
		},
	},
}

local lsp_keymaps = {
	{
		description = "Show Line Diagnostics",
		command = "<leader>d",
		action = vim.diagnostic.open_float,
	},
	{
		description = "Smart Rename",
		command = "<leader>rn",
		action = vim.lsp.buf.rename,
	},
	{
		description = "Jump to Previous Diagnostic",
		command = "[d",
		action = vim.diagnostic.goto_prev,
	},
	{
		description = "Jump to Next Diagnostic",
		command = "]d",
		action = vim.diagnostic.goto_next,
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
		config = function()
			-- install language servers
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(language_server_configs_by_name),
			})

			-- set keymaps for all lsps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(event)
					local opts = { buffer = event.buf, silent = true }

					for _, lsp_keymap in ipairs(lsp_keymaps) do
						opts.desc = lsp_keymap.desc
						vim.keymap.set("n", lsp_keymap.command, lsp_keymap.action, opts)
					end
				end,
			})

			-- configure and attach mason-installed lsps to lspconfig
			local lspconfig = require("lspconfig")
			for language_server_name, language_server_config in pairs(language_server_configs_by_name) do
				lspconfig[language_server_name].setup(language_server_config)
			end
		end,
	},
}
