local function plugin_is_installed(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

if plugin_is_installed("Comment.nvim") then
	local comment_api = require("Comment.api")

	vim.keymap.set("n", "<C-_><C-_>", function()
		comment_api.toggle.linewise.current()
	end, { noremap = true, silent = true })

	vim.keymap.set("v", "<C-_><C-_>", function()
		local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
		vim.api.nvim_feedkeys(esc, "x", false)
		comment_api.toggle.linewise(vim.fn.visualmode())
	end, { noremap = true, silent = true })
end
