-- General settings
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

-- Lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
local plugins = {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "luukvbaal/statuscol.nvim" },
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "saghen/blink.lib" },
		build = function()
			require("blink.cmp").build():pwait()
		end,

		opts = {
			keymap = { preset = "default" },
			sources = { default = { "path", "snippets", "buffer" } },
			fuzzy = { implementation = "lua" },
		},
	},
}
local opts = {}

require("lazy").setup(plugins, opts)

-- Theme setup
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "python", "bash", "lua" },
	highlight = { enable = true },
})

-- File tree
require("nvim-tree").setup({
	view = {
		side = "right",
	},
})

vim.keymap.set("n", "<leader>f", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle file explorer" })

-- Double line number columns
require("statuscol").setup({
	segments = { 
		{ text = { function(args) return "%=" .. args.relnum end }, click = "v:lua.ScLa" },
		{ text = { "  " } },
		{ text = { function(args) return "%=" .. args.lnum end }, click = "v:lua.ScLa" },
		{ text = { " " } },
	},
})
