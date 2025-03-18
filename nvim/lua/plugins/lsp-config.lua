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
					"r_language_server",
					"mdx_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			format = { timeout_ms = 10000 }
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						procMacro = {
							ignored = {
								leptos_macro = {
									"server",
								},
							},
						},
						rustfmt = {
							overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
						},
					},
				},
				capabilities = capabilities,
			})

			lspconfig.pyright.setup({
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic", -- Options: "off", "basic", "strict"
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						}
					}
				},
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.mdx_analyzer.setup({
				capabilities = capabilities,
			})

			lspconfig.r_language_server.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>bd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
