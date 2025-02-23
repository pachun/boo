return {
	setup = function()
		-- enable better colors for vim colorschemes in modern terminals
		vim.opt.termguicolors = true

		-- disable the welcome message
		vim.opt.shortmess:append("I")

		-- show line numbers relative to the cursor line, which shows it's real file line number
		vim.opt.relativenumber = true
		vim.opt.number = true

		-- do case insensitive searches unless the search includes mixed casing
		vim.opt.ignorecase = true
		vim.opt.smartcase = true

		-- hide line statuses to the left of line numbers; they make the gutter fatter and
		-- take up space which doesn't need to be taken up.
		vim.opt.signcolumn = "no"

		-- show grey icons for whitespace characters like tabs
		vim.opt.list = true

		-- disable swap files
		vim.opt.swapfile = false

		-- enable copy and paste between the vim and system clipboard
		vim.opt.clipboard:append("unnamedplus")

		-- Use 2 spaces instead of tabs
		vim.opt.expandtab = true
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		vim.opt.tabstop = 2
	end,
}
