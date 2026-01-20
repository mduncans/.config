vim.filetype.add({
	extension = {
		Rmd = "markdown",
	},
})


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto", "qmd" }, -- depending on your setup
  callback = function()
    local ext = vim.fn.expand("%:e")
    if ext == "Rmd" or ext == "qmd" then
      -- avoid activating on random markdown files
      vim.schedule(function()
        pcall(require, "quarto")
        if package.loaded["quarto"] then
          require("quarto").activate()
        end
      end)
    end
  end,
})
