return { 
	"nvim-treesitter/nvim-treesitter", 
	branch = "main", 
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"c",
			"python",
			"bash",
			"lua",
			"java",
			"markdown",
			"markdown_inline",
		})
	end,
}
