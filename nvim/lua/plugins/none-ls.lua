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

		local lsp_format_blocklist = { "clangd", "lua_ls", "jdtls" }

		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({
				filter = function(client)
					return not vim.tbl_contains(lsp_format_blocklist, client.name)
				end,
			})
		end, {})
	end,
}
