return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'L3MON4D3/LuaSnip', -- Optional: Snippets support
			'saadparwaiz1/cmp_luasnip' -- Optional: LuaSnip integration
		}
	},
	{
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
	    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
	    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
	    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
	    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
	    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	  },
	}
}

