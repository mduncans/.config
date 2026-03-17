return {
	"alexpasmantier/krust.nvim",
	ft = "rust",
	opts = {
		keymap = "<leader>k",
		float_win = {
			border = "rounded",
			auto_focus = false,
		},
	},
	config = function(_, opts)
		local krust = require("krust")
		krust.setup(opts)

		-- krust.nvim patches vim.lsp.start but does not guard nil configs.
		-- none-ls may call vim.lsp.start without a full config table.
		local current_start = vim.lsp.start
		local i = 1
		local original_start = nil
		while true do
			local name, value = debug.getupvalue(current_start, i)
			if not name then
				break
			end
			if name == "original_start" and type(value) == "function" then
				original_start = value
				break
			end
			i = i + 1
		end

		if not original_start then
			return
		end

		vim.lsp.start = function(config, start_opts)
			if type(config) ~= "table" then
				return original_start(config, start_opts)
			end
			if config.name == "rust_analyzer" or (type(config.cmd) == "table" and config.cmd[1] and config.cmd[1]:match("rust[-_]analyzer")) then
				config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
				config.capabilities.experimental = config.capabilities.experimental or {}
				config.capabilities.experimental.colorDiagnosticOutput = true
			end
			return original_start(config, start_opts)
		end
	end,
}
