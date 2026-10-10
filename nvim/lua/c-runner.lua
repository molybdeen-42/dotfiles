local M = {}

local function out_path()
	return vim.fn.expand("%:p:h") .. "/" .. vim.fn.expand("%:t:r")
end

local FLAGS_WARN = table.concat({
	"-Wall -Wextra -Werror",
	"-Wshadow",
	"-Wformat=2",
	"-Wstrict-prototypes",
	"-Wswitch-enum",
	"-Wundef",
	"-Wwrite-strings",
	"-fanalyzer",
}, " ")

local FLAGS_SANITIZED = FLAGS_WARN .. " -g -fsanitize=address,undefined"

local function compile_and_run(flags)
	local file = vim.fn.expand("%:p")
	if vim.bo.filetype ~= "c" or file == "" then
		vim.notify("Not a C file", vim.log.levels.WARN)
		return
	end

	vim.cmd("silent update")

	local out = vim.fn.shellescape(out_path())
	local cmd = string.format("gcc %s %s -o %s && %s", flags, vim.fn.shellescape(file), out, out)

	local term = require("toggleterm.terminal").get_or_create_term(1)
	local was_open = term:is_open()
	if not was_open then
		term:open()
	end

	local send = function()
		term:send(cmd, false)
	end

	if was_open then
		send()
	else
		vim.defer_fn(send, 300)
	end
end

function M.run()
	compile_and_run(FLAGS_WARN)
end

function M.run_sanitized()
	compile_and_run(FLAGS_SANITIZED)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	group = vim.api.nvim_create_augroup("CRunner", { clear = true }),
	callback = function()
		vim.keymap.set("n", "<leader>cc", M.run, { buffer = true, desc = "Compile and run" })
		vim.keymap.set("n", "<leader>cd", M.run_sanitized, { buffer = true, desc = "Compile and run (sanitized)" })
		vim.opt_local.makeprg = "gcc " .. FLAGS_WARN .. " % -o %:p:h/%:t:r"
		vim.opt_local.errorformat = "%f:%l:%c:%m"
	end,
})

return M
