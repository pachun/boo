local helpers = require("config.pachulski.helpers")

return {
	setup = function()
		vim.g["test#custom_strategies"] = {
			send_to_tmux_pane = function(cmd)
				if type(cmd) == "table" then
					helpers.tmux.send_to_pane(table.concat(cmd, " "))
				elseif type(cmd) == "string" then
					helpers.tmux.send_to_pane(cmd)
				else
					print("Error: Unexpected command format: " .. vim.inspect(cmd))
				end
			end,
		}

		vim.g["test#strategy"] = "send_to_tmux_pane"
	end,
}
