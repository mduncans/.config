vim.cmd("set tabstop=3")
vim.cmd("set shiftwidth=3")
vim.cmd("set softtabstop=3")

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true

vim.lsp.inlay_hint.enable(true)

vim.keymap.set("n", "<leader>sf", function()
	vim.api.nvim_put({
		"fn function() -> anyhow::Result<()> {",
		"	todo!()",
		"}"
	}, "l", true, true)
	vim.cmd("normal! kkk0w")
end, { desc = "Insert Rust function template" })
