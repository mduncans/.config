vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true

vim.lsp.inlay_hint.enable(true)

vim.keymap.set("n", "<leader>sf", function()
	vim.api.nvim_put({
		"fn function() -> anyhow::Result<()> {",
		"	todo!()",
		"}",
	}, "l", true, true)
	vim.cmd("normal! kkk0w")
end, { desc = "Insert Rust function template" })

vim.keymap.set("n", "<leader>rr", function()
	vim.api.nvim_put({
		"#' Title",
		"#'",
		"#' @param ",
		"#'",
		"#' @return",
		"#' @export",
		"#'",
		"#' @examples",
	}, "l", true, true)
end, { desc = "Insert roxygen template" })

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})

vim.keymap.set({ 'i', 'n', 'v' }, '<C-C>', '<esc>', { desc = 'Make Ctrl+C behave exactly like escape.' })

vim.diagnostic.config({
	virtual_text = true, -- Explicitly enable virtual text
	severity_sort = true,
	float = {
		border = "rounded",
	},
})
