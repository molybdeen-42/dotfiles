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
	local headings = { c.accentSoft, c.warn, c.positiveBright, c.accent, c.textMutedBright, c.textDim }
	for level, color in ipairs(headings) do
		local background = tint(c.bg, color, level <= 2 and 0.20 or 0.12)
		vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level, { fg = color, bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level .. "Bg", { fg = color, bg = background, bold = true })
		vim.api.nvim_set_hl(0, "@markup.heading." .. level .. ".markdown", { fg = color, bold = true })
	end

	local highlights = {
		Code = { bg = c.bgDark },
		CodeInfo = { fg = c.textMutedBright, bg = c.bgDark },
		CodeBorder = { fg = c.border, bg = c.bgDark },
		CodeInline = { fg = c.accentSoft, bg = c.surface },
		Quote = { fg = c.textMutedBright },
		Bullet = { fg = c.accent },
		Dash = { fg = c.borderBright },
		Link = { fg = c.accentSoft, underline = true },
		LinkTitle = { fg = c.accent },
		Unchecked = { fg = c.textMuted },
		Checked = { fg = c.positive },
		Todo = { fg = c.warn },
		TableHead = { fg = c.accent, bold = true },
		TableRow = { fg = c.borderBright },
		Success = { fg = c.positive },
		Info = { fg = c.accent },
		Hint = { fg = c.positiveBright },
		Warn = { fg = c.warn },
		Error = { fg = c.notify },
	}
	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, "RenderMarkdown" .. group, opts)
	end
end

return M
