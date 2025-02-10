return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"r_language_server",
					"mdx_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						autostart = true,
						checkOnSave = {
							enable = false,
						},
						diagnostics = {
							enable = false,
						},
					},
				},
			})
			lspconfig.mdx_analyzer.setup({})
			lspconfig.r_language_server.setup({})
			lspconfig.bacon_ls.setup({
				init_options = {
					updateOnSave = true,
					updateOnSaveWaitMillis = 1000,
					updateOnChange = false,
				},
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
