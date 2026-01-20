return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					languages = { "r", "python" },
					diagnostics = {
						enabled = true,
						triggers = { "BufWrite" },
					},
					completion = {
						enabled = true,
					},
				},
				codeRunner = {
					enabled = true,
					default_method = "slime",
					ft_runners = {},
					never_run = { "yaml", "yml", "toml" },
				},
			})
			vim.keymap.set("n", "<leader>qp", require("quarto").quartoPreview, { silent = true, noremap = true })
			 runner = require("quarto.runner")

			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "Run cell", silent = true })
			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "Run line", silent = true })
			vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "Run visual range", silent = true })
		end,
	},

	{ "jpalardy/vim-slime" },
	"ekickx/clipboard-image.nvim",
}
