return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("quarto").setup({
				lspFeatures = {
					enabled = true,
					languages = { "r", "python" },
					diagnostics = {
						enabled = true,
						triggers = { "BufWrite" },
					},
					completion = {
						enabled = true,
					},
				},
				codeRunner = {
					enabled = true,
					default_method = "slime",
					ft_runners = {},
					never_run = { "yaml", "yml", "toml" },
				},
			})
			vim.keymap.set("n", "<leader>qp", require("quarto").quartoPreview, { silent = true, noremap = true })
			local runner = require("quarto.runner")

			local function pane_exists(pane_id)
				if not pane_id or pane_id == "" then
					return false
				end
				local result = vim.fn.system({ "tmux", "list-panes", "-F", "#{pane_id}" })
				return result:find(pane_id, 1, true) ~= nil
			end

			local function ensure_r_pane()
				if vim.fn.exists("$TMUX") == 0 then
					vim.notify("tmux not detected; cannot open R pane", vim.log.levels.WARN)
					return false, false
				end

				vim.g.slime_target = "tmux"
				vim.g.slime_default_config = vim.g.slime_default_config or {
					socket_name = "default",
					target_pane = "{last}",
				}

				local pane = vim.g.quarto_r_pane_id
				if pane and pane ~= "" and pane_exists(pane) then
					vim.g.slime_default_config.target_pane = pane
					vim.b.slime_config = vim.tbl_extend("force", vim.b.slime_config or {}, {
						socket_name = vim.g.slime_default_config.socket_name or "default",
						target_pane = pane,
					})
					return true, false
				end
				-- Clear stale pane ID if it no longer exists
				vim.g.quarto_r_pane_id = nil

				local out = vim.fn.system({
					"tmux",
					"split-window",
					"-h",
					"-d",
					"-P",
					"-F",
					"#{pane_id}",
					"-c",
					"#{pane_current_path}",
					"R",
				})
				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to open tmux R pane: " .. vim.fn.trim(out), vim.log.levels.ERROR)
					return false, false
				end

				pane = vim.fn.trim(out)
				if pane == "" then
					vim.notify("tmux returned empty pane id", vim.log.levels.ERROR)
					return false, false
				end

				vim.g.quarto_r_pane_id = pane
				vim.g.slime_default_config.target_pane = pane
				vim.b.slime_config = vim.tbl_extend("force", vim.b.slime_config or {}, {
					socket_name = vim.g.slime_default_config.socket_name or "default",
					target_pane = pane,
				})
				return true, true
			end

			local function run_cell()
				local ok, created = ensure_r_pane()
				if not ok then
					return
				end
				if created then
					vim.defer_fn(function()
						runner.run_cell()
					end, 300)
					return
				end
				runner.run_cell()
			end

			local function run_line()
				local ok, created = ensure_r_pane()
				if not ok then
					return
				end
				if created then
					vim.defer_fn(function()
						runner.run_line()
					end, 300)
					return
				end
				runner.run_line()
			end

			local function send_visual()
				local ok, created = ensure_r_pane()
				if not ok then
					return
				end
				local send = function()
					local keys = vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, false, true)
					vim.api.nvim_feedkeys(keys, "x", false)
				end
				if created then
					vim.defer_fn(send, 300)
					return
				end
				send()
			end

			vim.keymap.set("n", "<leader>rc", run_cell, { desc = "Run cell", silent = true })
			vim.keymap.set("n", "<leader>rl", run_line, { desc = "Run line", silent = true })
			vim.keymap.set("v", "<leader>r", send_visual, { desc = "Send selection to REPL", silent = true })

		end,
	},

	{ "jpalardy/vim-slime" },
	"ekickx/clipboard-image.nvim",
}
