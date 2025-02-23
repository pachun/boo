local function hide_tabs_icons_in_lua_files()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "lua",
		callback = function()
			vim.opt_local.list = false
		end,
	})
end

local function rename_tmux_windows_to_vim_directory_name()
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
end

local function setup_lsp_keymaps()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = require("config.pachulski.keymaps").setup_lsp_keymaps,
	})
end

return {
	setup = function()
		hide_tabs_icons_in_lua_files()
		rename_tmux_windows_to_vim_directory_name()
	end,
	setup_lsp_keymaps = setup_lsp_keymaps,
}
