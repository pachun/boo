-- use space as the leader character
vim.g.mapleader = " "

-- lazy.nvim needs local leader set before it's initialized
vim.g.maplocalleader = "\\"

-- use jj instead of escape
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- :w/:W and :q/:Q both work to save or quit; it's too easy to keep holding shift after typing the colon :
vim.cmd("command! W w")
vim.cmd("command! Q q")

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

-- show line statuses to the left of line numbers; a bunch of plugins will use this. when not in use, it makes the gutter fatter
vim.opt.signcolumn = "yes"

-- show grey icons for whitespace characters like tabs
vim.opt.list = true

-- don't show tabs in lua files;
-- the formatter enforces they're there and they're ugly and they give me anxiety
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.list = false -- Disable for Lua files only
	end,
})

-- disable swap files
vim.opt.swapfile = false

-- enable copy and paste between the vim and system clipboard
vim.opt.clipboard:append("unnamedplus")

-- Use 2 spaces instead of tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Vim split hotkeys
vim.keymap.set("n", "<leader>d|", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>d_", "<C-w>s", { desc = "Split window horizontally" })

-- <leader>+ toggles maximizing the current pane, like tmux
_G.toggle_session = function()
	local session_file = "/tmp/vim_session_" .. vim.fn.getpid() .. ".vim"
	if vim.fn.filereadable(session_file) == 1 then
		vim.cmd("silent! source " .. session_file)
		vim.fn.delete(session_file)
	else
		vim.cmd("mks! " .. session_file)
		vim.cmd("wincmd o") -- Maximize current pane (Ctrl-w o)
	end
end
vim.api.nvim_set_keymap("n", "<leader>d+", ":lua _G.toggle_session()<CR>", { noremap = true, silent = true })

-- set diagnostic icons & messages
local signs = {
	Error = "",
	Warn = "",
	Hint = "󰠠",
	Info = "",
}

vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local icons = {
				[vim.diagnostic.severity.ERROR] = signs.Error,
				[vim.diagnostic.severity.WARN] = signs.Warn,
				[vim.diagnostic.severity.INFO] = signs.Info,
				[vim.diagnostic.severity.HINT] = signs.Hint,
			}

			return string.format(
				"%s %s [%s %s]",
				icons[diagnostic.severity],
				diagnostic.message,
				diagnostic.source,
				diagnostic.code
			)
		end,
		prefix = "",
		spacing = 2,
	},
	-- remove gutter signs
	signs = false,
	-- don't update lsp diagnostics while typing
	update_in_insert = false,
	-- don't underline errors
	underline = false,
})
vim.opt.signcolumn = "no"

-- Rename tmux window when nvim opens
if vim.fn.exists("$TMUX") == 1 then
	local function rename_tmux_tab()
		local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
		vim.fn.system('tmux rename-window "' .. cwd .. '"')
	end

	local function reset_tmux_tab()
		vim.fn.system("tmux set-window-option automatic-rename on")
	end

	rename_tmux_tab()

	vim.api.nvim_create_autocmd("DirChanged", { callback = rename_tmux_tab })
	vim.api.nvim_create_autocmd("VimLeavePre", { callback = reset_tmux_tab })
end
