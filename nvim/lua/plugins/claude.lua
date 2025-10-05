return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    require('claudecode').setup()
		vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
    vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
    vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })
	end,
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  }
}

