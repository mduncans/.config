local renderer_options = {
	mermaid = { scale = 3, background = "transparent" },
	plantuml = { charset = "utf-8" },
}

-- extract the diagram's title line ("title gpmx-pknca — current architecture",
-- also "title: ..." for mermaid frontmatter) and turn it into a filename slug
local function title_slug(source)
	for line in source:gmatch("[^\n]+") do
		local title = line:match("^%s*title%s*:?%s+(.-)%s*$")
		if title and title ~= "" then
			local slug = title:lower():gsub("%s+", "-"):gsub("[^%w%-]", ""):gsub("%-%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
			if slug ~= "" then
				return slug
			end
		end
	end
end

-- render the diagram fence at the cursor and save the PNG next to the current
-- file, named from the diagram's title line (falls back to the file's name)
local function save_diagram_png()
	local bufnr = vim.api.nvim_get_current_buf()
	local src = vim.api.nvim_buf_get_name(bufnr)
	if src == "" or vim.bo[bufnr].filetype ~= "markdown" then
		vim.notify("Not a saved markdown file", vim.log.levels.WARN)
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local target
	for _, d in ipairs(require("diagram.integrations.markdown").query_buffer_diagrams(bufnr)) do
		-- +/-1 so the cursor can sit on the ``` fence lines too
		if row >= d.range.start_row - 1 and row <= d.range.end_row + 1 then
			target = d
			break
		end
	end
	if not target then
		vim.notify("No diagram at cursor", vim.log.levels.WARN)
		return
	end

	local renderer = require("diagram.renderers." .. target.renderer_id)
	local result = renderer.render(target.source, renderer_options[target.renderer_id] or {})
	if not result then
		return
	end
	if result.job_id then
		vim.fn.jobwait({ result.job_id }, 30000)
	end
	if not vim.wait(5000, function()
		return vim.fn.filereadable(result.file_path) == 1
	end, 100) then
		vim.notify("Diagram render failed or timed out", vim.log.levels.ERROR)
		return
	end

	local slug = title_slug(target.source)
	local dest = slug and (vim.fn.fnamemodify(src, ":h") .. "/" .. slug .. ".png")
		or (vim.fn.fnamemodify(src, ":r") .. ".png")
	local ok, err = vim.uv.fs_copyfile(result.file_path, dest)
	if ok then
		vim.notify("Saved " .. vim.fn.fnamemodify(dest, ":~:."))
	else
		vim.notify("Failed to save diagram: " .. (err or "unknown error"), vim.log.levels.ERROR)
	end
end

return {
	"3rd/diagram.nvim",
	dependencies = {
		{
			"3rd/image.nvim",
			opts = {
				processor = "magick_cli",
				-- let inline diagrams use the full window height (default caps at 50%)
				max_height_window_percentage = 100,
				-- hide images when their window is covered by floats/popups
				window_overlap_clear_enabled = true,
				-- hide images when nvim loses focus (tmux pane switch, needs focus-events)
				editor_only_render_when_focused = true,
				-- hide images when the tmux window is switched away
				tmux_show_only_in_active_window = true,
				-- don't take over image file buffers (*.png etc. open in Preview instead)
				hijack_file_patterns = {},
			},
		},
	},
	ft = { "markdown" },
	keys = {
		{
			"<leader>ds",
			function()
				require("diagram").show_diagram_hover()
			end,
			desc = "Show Diagram (full tab)",
		},
		{
			"<leader>dS",
			save_diagram_png,
			desc = "Save Diagram PNG next to file",
		},
	},
	opts = {
		-- no inline auto-render; view diagrams on demand with <leader>ds
		events = {
			render_buffer = {},
		},
		renderer_options = renderer_options,
	},
}
