local session_file = "/tmp/vim_session_" .. vim.fn.getpid() .. ".vim"

local is_zoomed = function()
	return vim.fn.filereadable(session_file) == 1
end

local can_zoom = function()
	return vim.fn.winnr("$") > 1
end

local close_nvim_tree_buffers = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("NvimTree_%d+") then
			vim.api.nvim_win_close(win, true) -- Force close the NvimTree window
		end
	end
end

local unzoom = function()
	local saved_cursor_position = vim.fn.winsaveview()
	vim.cmd("silent! source " .. session_file)
	vim.fn.delete(session_file)
	close_nvim_tree_buffers()
	vim.fn.winrestview(saved_cursor_position)
end

local zoom = function()
	vim.cmd("mks! " .. session_file)
	vim.cmd("wincmd o")
end

local split = function()
	if is_zoomed() then
		vim.notify("Can't split. Unzoom before splitting (<leader>d+)", vim.log.levels.WARN)
	else
		vim.cmd("split")
	end
end

local vsplit = function()
	if is_zoomed() then
		vim.notify("Can't split. Unzoom before splitting (<leader>d+)", vim.log.levels.WARN)
	else
		vim.cmd("vsplit")
	end
end

local toggle_zoom = function()
	if is_zoomed() then
		unzoom()
	elseif can_zoom() then
		zoom()
	else
		vim.notify("Can't zoom. Only one pane is open.", vim.log.levels.WARN)
	end
end

return {
	split = split,
	vsplit = vsplit,
	toggle_zoom = toggle_zoom,
}
