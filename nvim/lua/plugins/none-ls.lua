return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		null_ls.setup({
			sources = {
				-- C
				formatting.clang_format.with({
					extra_args = {
						"--style",
						"{BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: ForIndentation}",
					},
				}),

				-- Lua
				formatting.stylua.with({
					extra_args = {
						"--indent-type",
						"Tabs",
						"--indent-width",
						"8",
					},
				}),

				-- bash
				formatting.shfmt.with({
					extra_args = {
						"-i",
						"0",
					},
				}),

				-- Python
				formatting.black,
				formatting.isort,

				-- Java
				formatting.google_java_format,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
