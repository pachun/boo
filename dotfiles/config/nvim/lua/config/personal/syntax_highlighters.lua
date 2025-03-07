-- you can list the available syntax highlights on the cli with:
-- nvim --headless +"lua print(table.concat(require('nvim-treesitter.parsers').available_parsers(), '\n'))" +q
--
-- they're also list here:
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
local syntax_highlighters = {
	"bash",
	"c",
	"css",
	"csv",
	"diff",
	"dockerfile",
	"elixir",
	"elm",
	"git_config",
	"git_rebase",
	"gitcommit",
	"gitignore",
	"go",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"objc",
	"python",
	"ruby",
	"scss",
	"swift",
	"tmux",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return syntax_highlighters
