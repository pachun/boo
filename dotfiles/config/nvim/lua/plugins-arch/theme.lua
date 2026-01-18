local theme = require("config.personal.theme")

vim.o.background = theme.dark.style
vim.cmd.colorscheme(theme.dark.name)

return {}
