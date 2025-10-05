return {
  "christoomey/vim-tmux-navigator",
  cmd = {
	 "TmuxNavigateLeft",
	 "TmuxNavigateDown",
	 "TmuxNavigateUp",
	 "TmuxNavigateRight",
	 "TmuxNavigatePrevious",
	 "TmuxNavigatorProcessList",
  },
  keys = {
	 -- Normal mode navigation
	 { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
	 { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
	 { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
	 { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
	 { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	 -- Terminal mode navigation (escape to normal mode first)
	 { "<c-h>", "<c-\\><c-n><cmd>TmuxNavigateLeft<cr>", mode = "t" },
	 { "<c-j>", "<c-\\><c-n><cmd>TmuxNavigateDown<cr>", mode = "t" },
	 { "<c-k>", "<c-\\><c-n><cmd>TmuxNavigateUp<cr>", mode = "t" },
	 { "<c-l>", "<c-\\><c-n><cmd>TmuxNavigateRight<cr>", mode = "t" },
	 { "<c-\\>", "<c-\\><c-n><cmd>TmuxNavigatePrevious<cr>", mode = "t" },
  }
}
