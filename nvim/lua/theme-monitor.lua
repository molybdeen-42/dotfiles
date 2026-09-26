-- Theme monitor
local timer = nil
local debounce_ms = 300

local function reload_theme()
	package.loaded["theme"] = nil

	local ok, theme = pcall(require, "theme")
	if not ok then
		return
	end

	theme.apply()

	pcall(function()
		require("lualine").setup({
			options = {
				theme = theme.lualine
			}
		})
	end)
end

local function schedule()
	if timer then
		timer:again()
	else
		timer = vim.loop.new_timer()
	end

	timer:start(debounce_ms, 0, vim.schedule_wrap(function()
		timer:stop()
		timer:close()
		timer = nil
		reload_theme()
	end))
end

local fs_event = vim.loop.new_fs_event()
vim.loop.fs_event_start(fs_event, vim.fn.stdpath("config") .. "/lua/theme.lua", {}, function(err, _, events)
	if err or not(events.change or events.rename) then
		return
	end
	vim.schedule(schedule)
end)
