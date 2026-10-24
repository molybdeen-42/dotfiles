local M = {}

local function tint(background, foreground, amount)
	local channels = {}
	for offset = 2, 6, 2 do
		local bg = tonumber(background:sub(offset, offset + 1), 16)
		local fg = tonumber(foreground:sub(offset, offset + 1), 16)
		channels[#channels + 1] = math.floor(bg + (fg - bg) * amount + 0.5)
	end
	return string.format("#%02x%02x%02x", channels[1], channels[2], channels[3])
end

function M.apply(c)
	local colors = {
		Add = c.positive,
		Change = c.warn,
		Delete = c.notify,
		Changedelete = c.warn,
		Topdelete = c.notify,
		Untracked = c.positive,
	}
	for kind, color in pairs(colors) do
		vim.api.nvim_set_hl(0, "GitSigns" .. kind, { fg = color, bg = c.bg })
		vim.api.nvim_set_hl(0, "GitSignsStaged" .. kind, { fg = tint(c.bg, color, 0.65), bg = c.bg })
		if kind ~= "Delete" and kind ~= "Topdelete" then
			vim.api.nvim_set_hl(0, "GitSigns" .. kind .. "Ln", { bg = tint(c.bg, color, 0.16) })
			vim.api.nvim_set_hl(0, "GitSignsStaged" .. kind .. "Ln", { bg = tint(c.bg, color, 0.10) })
		end
	end

	vim.api.nvim_set_hl(0, "DiffAdd", { bg = tint(c.bg, c.positive, 0.16) })
	vim.api.nvim_set_hl(0, "DiffChange", { bg = tint(c.bg, c.warn, 0.16) })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = c.notify, bg = tint(c.bg, c.notify, 0.16) })
	vim.api.nvim_set_hl(0, "DiffText", { bg = tint(c.bg, c.warn, 0.30) })
end

return M
