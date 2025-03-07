-- available formatters are listed in `:Mason` tab 5
-- show filetypes with `:set filetype?`
local formatters = {
	prettier = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"css",
		"html",
		"json",
		"yaml",
		"markdown",
	},
	stylua = { "lua" },
}

return formatters
