local function setup_keymap(keymap, options)
	local opts = vim.tbl_extend("force", options or {}, { desc = keymap.description, silent = true, noremap = true })

	vim.keymap.set(keymap.mode, keymap.command, keymap.action, opts)
end

return setup_keymap
