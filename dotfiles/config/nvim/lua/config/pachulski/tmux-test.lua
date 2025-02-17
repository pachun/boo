local function filename()
	return vim.fn.expand("%:p")
end

local function jest_filename()
	return filename():gsub("([%[%]()%./])", "\\%1")
end

local function line_number()
	return vim.api.nvim_win_get_cursor(0)[1]
end

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

local function run_in_first_available_tmux_pane_in_the_same_working_directory(command)
	local target_pane = first_available_tmux_pane_in_the_same_working_directory()

	if target_pane then
		local tmux_command = "tmux send-keys -t " .. target_pane .. " " .. vim.fn.shellescape(command) .. " C-m"
		vim.fn.system(tmux_command)
	else
		print("No suitable tmux pane found.")
	end
end

local function is_jest_test()
	local patterns = {
		"^.+%.spec%.js$",
		"^.+%.spec%.ts$",
		"^.+%.spec%.jsx$",
		"^.+%.spec%.tsx$",
		"^.+%.test%.js$",
		"^.+%.test%.ts$",
		"^.+%.test%.jsx$",
		"^.+%.test%.tsx$",
	}

	for _, pattern in ipairs(patterns) do
		if filename():match(pattern) then
			return true
		end
	end
end

local function is_rspec_test()
	local pattern = "^.+%_spec%.rb$"
	return filename():match(pattern)
end

local function is_elixir_test()
	local pattern = "^.+%_test%.exs$"
	return filename():match(pattern)
end

local function run_nearest_jest_test_command()
	local test_description = nil

	for i = line_number(), 1, -1 do
		local line = vim.fn.getline(i)
		local match = line:match('%s*it%s*%(%s*["](.-)["]')
			or line:match("%s*it%s*%(%s*['](.-)[']")
			or line:match('%s*test%s*%(%s*["](.-)["]')
			or line:match("%s*test%s*%(%s*['](.-)[']")

		if match then
			test_description = match
			break
		end
	end

	if test_description == nil then
		print("No Jest test block found.")
		return
	end

	test_description = test_description:gsub('"', '\\"')

	local test_command = "clear; yarn test --testPathPattern='"
		.. jest_filename()
		.. "' --testNamePattern=\""
		.. test_description
		.. '"'

	return test_command
end

local function run_jest_test_file_command()
	return "clear; yarn test --testPathPattern='" .. jest_filename() .. "'"
end

local function run_all_jest_tests_command()
	return "clear; yarn test"
end

local function run_nearest_rspec_test_command()
	return "clear; bundle exec rspec " .. filename() .. ":" .. line_number()
end

local function run_nearest_elixir_test_command()
	return "clear; mix test " .. filename() .. ":" .. line_number()
end

local function run_rspec_test_file_command()
	return "clear; bundle exec rspec " .. filename()
end

local function run_elixir_test_file_command()
	return "clear; mix test " .. filename()
end

local function run_all_rspec_tests_command()
	return "clear; bundle exec rspec"
end

local function run_all_elixir_tests_command()
	return "clear; mix test"
end

local test_types = {
	rspec = {
		is_test_file = is_rspec_test,
		nearest = run_nearest_rspec_test_command,
		file = run_rspec_test_file_command,
		all = run_all_rspec_tests_command,
	},
	elixir = {
		is_test_file = is_elixir_test,
		nearest = run_nearest_elixir_test_command,
		file = run_elixir_test_file_command,
		all = run_all_elixir_tests_command,
	},
	jest = {
		is_test_file = is_jest_test,
		nearest = run_nearest_jest_test_command,
		file = run_jest_test_file_command,
		all = run_all_jest_tests_command,
	},
}

function RunTest(test_location)
	for _, test_type in pairs(test_types) do
		if test_type.is_test_file() then
			return run_in_first_available_tmux_pane_in_the_same_working_directory(test_type[test_location]())
		end
	end
end

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<leader>s", ":lua RunTest('nearest')<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>t", ":lua RunTest('file')<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>a", ":lua RunTest('all')<CR>", opts)
