vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true

local utility_filetypes = { ["neo-tree"] = true, toggleterm = true }
local closing_utilities = false

vim.api.nvim_create_autocmd("QuitPre", {
	group = vim.api.nvim_create_augroup("CloseUtilitiesOnQuit", { clear = true }),
	callback = function()
		if closing_utilities then
			return
		end

		local current_win = vim.api.nvim_get_current_win()
		if utility_filetypes[vim.bo.filetype] or vim.api.nvim_win_get_config(current_win).relative ~= "" then
			return
		end

		local utility_windows = {}
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if win ~= current_win then
				local buf = vim.api.nvim_win_get_buf(win)
				if utility_filetypes[vim.bo[buf].filetype] then
					table.insert(utility_windows, win)
				elseif vim.api.nvim_win_get_config(win).relative == "" then
					return
				end
			end
		end

		-- Closing a window can trigger QuitPre again.
		closing_utilities = true
		for _, win in ipairs(utility_windows) do
			if vim.api.nvim_win_is_valid(win) then
				pcall(vim.api.nvim_win_close, win, true)
			end
		end
		closing_utilities = false
	end,
})
