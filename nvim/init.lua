vim.cmd("set tabstop=3")
vim.cmd("set shiftwidth=3")
vim.cmd("set softtabstop=3")
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

require("lazy").setup("plugins", opts)

local cmp = require('cmp')

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' } -- Optional: for snippet expansion
  }
})

vim.lsp.inlay_hint.enable(ture)

vim.g.rustaceanvim = {
	server = {
		settings = { ['rust-analyzer'] = {} }
  }
}
