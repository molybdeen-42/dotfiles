return { 
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = { 
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "right",
			},
		})
		vim.keymap.set("n", "<leader>fs", ":Neotree toggle<CR>")
		vim.keymap.set("n", "<leader>ff", function()
			if vim.bo.filetype == "neo-tree" then
				vim.cmd("wincmd p")
			else
				vim.cmd("Neotree focus")
			end
		end)

		local function neotree_win_exists()
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype == "neo-tree" then
					return true
				end
			end
			return false
		end

		vim.keymap.set("n", "<leader>ft", function()
			if neotree_win_exists() then
				vim.cmd("Neotree close")
				return
			end
			local cur_win = vim.api.nvim_get_current_win()
			vim.cmd("Neotree show")
			if vim.api.nvim_win_is_valid(cur_win) and vim.api.nvim_get_current_win() ~= cur_win then
				vim.api.nvim_set_current_win(cur_win)
			end
		end)
	end,
}
