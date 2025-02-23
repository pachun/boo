-- keynames listed here will be installed by mason-tool-installer
--
-- browse the available formatters in `:Mason` on tab 5
--
-- the values for each formatter are the filetypes that it should
-- automatically format on save.
--
-- to find your filetype, create a file you want the formatter
-- applied to and run `:set filetype?`
--
-- formatters are applied to filetypes on save by conform

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
