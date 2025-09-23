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
					"mdx_analyzer",
					"pyright",
					"lemminx",
					"jsonls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			format = { timeout_ms = 10000 },
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config('rust_analyzer', {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							features = "all"
						},
						procMacro = {
							ignored = {
								leptos_macro = {
									"server",
								},
							},
						},
						rustfmt = {},
					},
				},
				capabilities = capabilities,
			})

			vim.lsp.config('pyright', {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
				capabilities = capabilities,
			})

			vim.lsp.config('lua_ls', {
				capabilities = capabilities,
			})

			vim.lsp.config('mdx_analyzer', {
				capabilities = capabilities,
			})

			vim.lsp.config('air', {
				cmd = { "air" },
				filetypes = { "r", "R", "rmd", "Rmd", "quarto", "qmd" },
				capabilities = capabilities,
			})

			vim.lsp.config('lemminx', {
				filetypes = { "xml" },
				capabilities = capabilities,
			})

			vim.lsp.config('jsonls', {
				filetypes = { "json" },
				capabilities = capabilities,
			})

			vim.lsp.enable('rust_analyzer')
			vim.lsp.enable('pyright')
			vim.lsp.enable('lua_ls')
			vim.lsp.enable('mdx_analyzer')
			vim.lsp.enable('air')
			vim.lsp.enable('lemminx')
			vim.lsp.enable('jsonls')

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>bd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
