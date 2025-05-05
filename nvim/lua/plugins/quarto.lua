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
					never_run = { "yaml", "yml" },
				},
			})
			vim.keymap.set("n", "<leader>qp", require("quarto").quartoPreview, { silent = true, noremap = true })

			vim.keymap.set("n", "<C-CR>", function()
				require("quarto.runner").run_line()
			end, { silent = true, noremap = true })

			vim.keymap.set("n", "<S-C-CR>", function()
				require("quarto.runner").run_cell()
			end, { silent = true, noremap = true })

		end,
	},

	{ "jpalardy/vim-slime" },
	"ekickx/clipboard-image.nvim",
}
