return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local term_height = 15

		require("toggleterm").setup({
			size = term_height,
			open_mapping = [[<C-\>]],
			direction = "float",
			hide_numbers = true,
			start_in_insert = true,
			close_on_exit = true,
			shade_terminals = false,
			float_opts = {
				border = "single",
				relative = "editor",
				width = function()
					return vim.o.columns
				end,
				height = function()
					return term_height
				end,
				row = function()
					local statusline = 0
					if vim.o.laststatus == 2 or vim.o.laststatus == 3 or (vim.o.laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1) then
						statusline = 1
					end
					return vim.o.lines - vim.o.cmdheight - statusline - term_height - 2
				end,
				col = 0,
			},
			on_open = function(term)
				local win = term.window or vim.api.nvim_get_current_win()
				vim.api.nvim_set_option_value(
					"winhighlight",
					"FloatBorder:ToggleTermBorder,NormalFloat:ToggleTermNormal",
					{ win = win }
				)
			end,
		})

		vim.api.nvim_clear_autocmds({ group = "ToggleTermCommands", event = "WinLeave" })

		local function swap_terminal_focus()
			if vim.bo.filetype == "toggleterm" then
				vim.cmd("wincmd p")
				return
			end
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype == "toggleterm" then
					vim.api.nvim_set_current_win(win)
					vim.cmd("startinsert")
					return
				end
			end
			vim.cmd("ToggleTerm")
		end

		vim.keymap.set({ "n", "t" }, "<C-]>", swap_terminal_focus)

		require("c-runner")
	end,
}
