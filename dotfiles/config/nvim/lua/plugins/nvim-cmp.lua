_G.cmp_enabled = true

return {
	"hrsh7th/nvim-cmp",
	dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp" },
	config = function()
		local cmp = require("cmp")
		local do_not_insert_hovered_items = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			enabled = function()
				return _G.cmp_enabled
			end,
			-- this auto-hovers the first item in the completion list
			completion = { completeopt = "" },
			mapping = {
				["<C-j>"] = cmp.mapping.select_next_item(do_not_insert_hovered_items),
				["<C-k>"] = cmp.mapping.select_prev_item(do_not_insert_hovered_items),
				["<C-l>"] = cmp.mapping.confirm(),
				["<C-h>"] = cmp.mapping.abort(),
			},
			-- the order of these determines the order in the completion list
			sources = {
				-- the following source only works if nvim-lspconfig passes:
				--
				-- capabilities = require("cmp_nvim_lsp").default_capabilities(),
				--
				-- to each language server in the language server configuration
				{ name = "nvim_lsp" },

				{ name = "buffer" },
				{ name = "path" },
			},
		})
	end,
}
