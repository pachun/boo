local function current_directory()
	return vim.fn.getcwd()
end

local function tmux_panes()
	return vim.fn.systemlist(
		"tmux list-panes -F '#{pane_index} #{pane_pid} #{pane_current_command} #{pane_current_path}'"
	)
end

local function first_available_tmux_pane_in_the_same_working_directory()
	local target_pane = nil
	for _, tmux_pane in ipairs(tmux_panes()) do
		local index, _, command, path = tmux_pane:match("^(%d+) (%d+) ([%w%p]*) (.+)$")
		if command == "zsh" and path == current_directory() then
			target_pane = index
			break
		end
	end
	return target_pane
end

local function send_to_pane(command)
	local target_pane = first_available_tmux_pane_in_the_same_working_directory()

	if target_pane then
		local tmux_command = "tmux send-keys -t " .. target_pane .. " " .. vim.fn.shellescape(command) .. " C-m"
		vim.fn.system(tmux_command)
	else
		print("No suitable tmux pane found.")
	end
end

return {
	send_to_pane = send_to_pane,
}
