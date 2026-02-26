vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true

vim.lsp.inlay_hint.enable(true)

vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = 1
vim.g.slime_default_config = {
	socket_name = "default",
	target_pane = "{last}",
}

-- Function to extract parameters from function signature
local function extract_params_from_function()
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	local total_lines = vim.api.nvim_buf_line_count(0)

	-- Search backwards and forwards for function signature
	local function_start_line = nil
	local search_range = 10

	-- Search backwards first (for when cursor is after function)
	for i = 0, search_range do
		if line_num - i > 0 then
			local line = vim.api.nvim_buf_get_lines(0, line_num - i - 1, line_num - i, false)[1] or ""
			if line:match("^%s*pub%s+fn%s+") or line:match("^%s*fn%s+") or line:match("^%s*function") or line:match("^[%w_]+%s*<%-") then
				function_start_line = line_num - i
				break
			end
		end
	end

	-- If not found backwards, search forwards
	if not function_start_line then
		for i = 0, search_range do
			if line_num + i <= total_lines then
				local line = vim.api.nvim_buf_get_lines(0, line_num + i - 1, line_num + i, false)[1] or ""
				if line:match("^%s*pub%s+fn%s+") or line:match("^%s*fn%s+") or line:match("^%s*function") or line:match("^[%w_]+%s*<%-") then
					function_start_line = line_num + i
					break
				end
			end
		end
	end

	if not function_start_line then
		return {}
	end

	-- Collect the full function signature (may span multiple lines)
	local function_lines = {}
	local paren_count = 0
	local found_opening_paren = false

	for i = function_start_line, math.min(function_start_line + 10, total_lines) do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
		table.insert(function_lines, line)

		-- Count parentheses to find complete signature
		for char in line:gmatch(".") do
			if char == "(" then
				paren_count = paren_count + 1
				found_opening_paren = true
			elseif char == ")" then
				paren_count = paren_count - 1
			end
		end

		-- Stop when we've found the complete signature
		if found_opening_paren and paren_count == 0 then
			break
		end
	end

	local full_signature = table.concat(function_lines, " ")
	local params = {}

	-- Extract parameters from the complete signature
	local param_section = full_signature:match("%(([^%)]*)")
	if param_section then
		-- Clean up whitespace and newlines
		param_section = param_section:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

		-- Rust function pattern: param_name: Type
		if full_signature:match("fn%s+") then
			for param in param_section:gmatch("([%w_]+)%s*:%s*[^,]+") do
				if param ~= "self" then
					table.insert(params, param)
				end
			end
		end

		-- R function pattern: param_name = default or just param_name
		if full_signature:match("<%-") or full_signature:match("function") then
			for param in param_section:gmatch("([%w_%.]+)%s*[=,]?") do
				param = param:gsub("%s*$", "")
				if param ~= "" then
					table.insert(params, param)
				end
			end
		end
	end

	return params
end

vim.keymap.set("n", "<leader>rr", function()
	local params = extract_params_from_function()
	local template = {
		"#' Title",
		"#'",
	}

	-- Add @param lines for each parameter
	for _, param in ipairs(params) do
		table.insert(template, "#' @param " .. param .. " ")
	end

	-- Add remaining template
	vim.list_extend(template, {
		"#'",
		"#' @return",
		"#' @export",
		"#'",
		"#' @examples",
	})

	vim.api.nvim_put(template, "l", true, true)
end, { desc = "Insert roxygen template with auto params" })

vim.keymap.set("n", "<leader>rx", function()
	local params = extract_params_from_function()
	local template = {
		"/// Title",
		"///",
	}

	-- Add @param lines for each parameter
	for _, param in ipairs(params) do
		table.insert(template, "/// @param " .. param .. " ")
	end

	-- Add remaining template
	vim.list_extend(template, {
		"///",
		"/// @return",
		"/// @export",
		"///",
		"/// @examples",
	})

	vim.api.nvim_put(template, "l", true, true)
end, { desc = "Insert roxygen template with auto params" })

local function insert_empty_r_block()
	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	vim.api.nvim_buf_set_lines(0, row, row, true, { "```{r}", "", "```" })
	vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
	vim.cmd("startinsert")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "quarto", "r", "rmd" },
	callback = function()
		vim.keymap.set("n", "<leader>I", insert_empty_r_block, {
			buffer = true,
			desc = "Insert empty R code block",
		})
		vim.keymap.set("n", "<leader>L", "a <Bar>><CR><Tab>", {
			buffer = true,
			desc = "Insert pipe and newline",
		})
		-- Pipe operator like RStudio's Cmd+Shift+M
		vim.keymap.set("n", "<M-m>", "a <Bar>><CR><Tab>", {
			buffer = true,
			desc = "Insert pipe and newline",
		})
		vim.keymap.set("i", "<M-m>", " <Bar>><CR><Tab>", {
			buffer = true,
			desc = "Insert pipe and newline",
		})
	end,
})

vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})

vim.keymap.set({ 'i', 'n', 'v' }, '<C-C>', '<esc>', { desc = 'Make Ctrl+C behave exactly like escape.' })

vim.diagnostic.config({
	virtual_text = true, -- Explicitly enable virtual text
	severity_sort = true,
	float = {
		border = "rounded",
	},
})
