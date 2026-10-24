return {
	"luukvbaal/statuscol.nvim",
	config = function()
		require("statuscol").setup({
			ft_ignore = { "neo-tree" },
			segments = {
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{
					text = {
						function(args)
							return "%=" .. args.relnum
						end,
					},
					click = "v:lua.ScLa",
				},
				{ text = { "  " } },
				{
					text = {
						function(args)
							return "%=" .. args.lnum
						end,
					},
					click = "v:lua.ScLa",
				},
				{ text = { " " } },
			},
		})
	end,
}
