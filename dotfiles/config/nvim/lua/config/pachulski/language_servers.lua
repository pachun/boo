-- available lsps are listed in `:Mason` tab 2
-- for configuration help, ask ChatGPT

local language_servers = {
	elixirls = {
		cmd = { "elixir-ls" },
	},
	ts_ls = {
		on_attach = function(client, _)
			-- Disable formatting from tsserver; we use prettier
			client.server_capabilities.documentFormattingProvider = false
		end,
	},
	lua_ls = {
		settings = {
			Lua = {
				-- Enable better lsp autocompletion
				completion = {
					callSnippet = "Replace",
				},
				-- Prevent "undefined global 'vim'" warning
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
}

return language_servers
