return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"r",
				"python",
				"rust",
				"html",
				"markdown",
				"markdown_inline",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
