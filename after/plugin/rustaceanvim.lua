vim.g.rustaceanvim = {
	server = {
		on_attach = function(client, bufnr)
			-- Hover actions
			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end)

			-- Code action groups
			vim.keymap.set("n", "<leader>la", function()
				vim.cmd.RustLsp("codeAction")
			end)

			-- Expand macro
			vim.keymap.set("n", "<leader>le", function()
				vim.cmd.RustLsp("expandMacro")
			end)

			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "<leader>lws", function()
				vim.cmd.RustLsp("workspaceSymbol")
			end)
			vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)
			vim.keymap.set("n", "<leader>lj", function()
				vim.cmd.RustLsp("explainError")
			end)
			vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)
			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
			vim.keymap.set("n", "gr", vim.lsp.buf.references)

			-- Toggle inlay hints
			-- if client.server_capabilities.inlayHintProvider then
			--     vim.keymap.set("n", "<leader>h", function()
			--         local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
			--         vim.lsp.inlay_hint.enable(bufnr, not current_setting)
			--     end)
			-- end

			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
		settings = {
			["rust-analyzer"] = {
				inlayHints = {
					bindingModeHints = {
						enable = false,
					},
					chainingHints = {
						enable = true,
					},
					closingBraceHints = {
						enable = true,
						minLines = 25,
					},
					closureReturnTypeHints = {
						enable = "never",
					},
					lifetimeElisionHints = {
						enable = "never",
						useParameterNames = false,
					},
					maxLength = 25,
					parameterHints = {
						enable = true,
					},
					reborrowHints = {
						enable = "never",
					},
					renderColons = true,
					typeHints = {
						enable = true,
						hideClosureInitialization = false,
						hideNamedConstructor = false,
					},
				},
			},
		},
	},
}
