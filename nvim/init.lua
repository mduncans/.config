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

-- Force-load vim.snippet so nvim's default <Tab> insert-mode keymap doesn't
-- try to lazy-require it via lazy.nvim's loader (which can't find files in
-- nvim's own runtime and fails inside callback contexts like nvim-cmp's
-- keymap.solve). Once cached in package.loaded, the vim.__index path is
-- bypassed entirely.
pcall(require, "vim.snippet")

require("vim-options")
require("lazy").setup("plugins")
