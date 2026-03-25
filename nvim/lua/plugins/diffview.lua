return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
		{ "<leader>dm", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff against main" },
		{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
		{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
	},
	opts = {},
}
