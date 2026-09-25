return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local theme = require("theme")
		require("lualine").setup({
			options = {
				theme = theme.lualine
			}
		})
	end,
}
