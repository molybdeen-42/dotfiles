return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	keys = {
		{ "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown preview" },
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
}
