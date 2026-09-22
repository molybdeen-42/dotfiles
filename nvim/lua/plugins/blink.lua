return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"saghen/blink.lib",
	},
	build = function()
		require("blink.cmp").build():pwait()
	end,

	opts = {
		keymap = {
			preset = "super-tab",
		},
		completion = {
			ghost_text = { enabled = true },
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
		},
		fuzzy = {
			implementation = "lua",
		},
	},
}
