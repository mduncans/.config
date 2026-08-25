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
	 { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
	 { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
	 { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
	 { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
	 { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
	 -- Terminal mode navigation (escape to normal mode first)
	 { "<c-h>", "<c-\\><c-n><cmd>TmuxNavigateLeft<cr>", mode = "t" },
	 { "<c-j>", "<c-\\><c-n><cmd>TmuxNavigateDown<cr>", mode = "t" },
	 { "<c-k>", "<c-\\><c-n><cmd>TmuxNavigateUp<cr>", mode = "t" },
	 { "<c-l>", "<c-\\><c-n><cmd>TmuxNavigateRight<cr>", mode = "t" },
	 -- no terminal-mode <c-\>: it would swallow the <c-\><c-n> escape sequence
  }
}
