return { 
	"luukvbaal/statuscol.nvim",
	config = function()
		require("statuscol").setup({
			segments = { 
				{ text = { function(args) return "%=" .. args.relnum end }, click = "v:lua.ScLa" },
				{ text = { "  " } },
				{ text = { function(args) return "%=" .. args.lnum end }, click = "v:lua.ScLa" },
				{ text = { " " } },
			},
		})
	end,
}
