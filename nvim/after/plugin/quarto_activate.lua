vim.api.nvim_create_autocmd("FileType", {
  pattern = { "quarto" },
  callback = function()
    vim.schedule(function()
      local ok, quarto = pcall(require, "quarto")
      if ok then
        quarto.activate()
      end
    end)
  end,
})
