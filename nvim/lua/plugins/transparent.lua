return {
	{
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({
			  groups = {
				 'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
				 'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
				 'Conditional', 'Repeat', 'Operator', 'Structure', 'NonText',
				 'SignColumn', 'CursorLine', 'CursorLineNr', 'LineNr', 'StatusLine', 'StatusLineNC',
				 'EndOfBuffer',
			  },
			  extra_groups = {},
			  exclude_groups = {},
			  on_clear = function() end,
			})

			vim.cmd("highlight LineNr guifg=#cdd6f4")
		end
	}
}
