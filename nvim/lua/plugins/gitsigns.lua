return {
	"lewis6991/gitsigns.nvim",
	config = function()
		vim.opt.signcolumn = "yes"

		require("gitsigns").setup({
			linehl = true,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, "Next Git change")

				map("[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, "Previous Git change")

				map("<leader>hp", gitsigns.preview_hunk, "Preview Git change")
				map("<leader>hd", gitsigns.diffthis, "Diff file against Git index")
			end,
		})

		vim.keymap.set("n", "<leader>gd", function()
			require("gitsigns").toggle_linehl()
		end, { desc = "Toggle Git diff line highlights" })
	end,
}
