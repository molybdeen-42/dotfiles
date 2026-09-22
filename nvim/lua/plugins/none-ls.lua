return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- C
				null_ls.builtins.formatting.clang_format,

				-- Lua
				null_ls.builtins.formatting.stylua,

				-- bash 
				null_ls.builtins.formatting.shfmt,

				-- Python
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,

				-- Java
				null_ls.builtins.formatting.google_java_format
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
