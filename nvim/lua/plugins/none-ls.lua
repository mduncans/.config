return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		local h = require("null-ls.helpers")
		local methods = require("null-ls.methods")

		local lintr = h.make_builtin({
			name = "lintr",
			method = methods.internal.DIAGNOSTICS,
			filetypes = { "r" },
			generator_opts = {
				command = "Rscript",
				args = {
					"--vanilla",
					"-e",
					'lints <- lintr::lint("$FILENAME"); for (l in lints) cat(sprintf("%s:%d:%d: %s: %s\\n", l$filename, l$line_number, l$column_number, l$type, l$message))',
				},
				to_stdin = false,
				to_temp_file = true,
				ignore_stderr = true,
				format = "line",
				on_output = h.diagnostics.from_patterns({
					{
						pattern = [[.+:(%d+):(%d+): (%w+): (.+)]],
						groups = { "row", "col", "severity", "message" },
						overrides = {
							severities = {
								style = h.diagnostics.severities["information"],
								warning = h.diagnostics.severities["warning"],
								error = h.diagnostics.severities["error"],
							},
						},
					},
				}),
			},
			factory = h.generator_factory,
		})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.prettier.with({
					filetypes = {
						"json",
						"jsonc",
						"typescript",
						"typescriptreact",
						"javascript",
						"javascriptreact",
					},
				}),
				lintr,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
