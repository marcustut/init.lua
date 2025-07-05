local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, opts)
	vim.keymap.set("n", "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)
	vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>lf", require("conform").format)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

	-- Toggle inlay hints
	if client.server_capabilities.inlayHintProvider then
		vim.keymap.set("n", "<leader>h", function()
			local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
			vim.lsp.inlay_hint.enable(bufnr, not current_setting)
		end)
	end

	-- Diagnostic Config
	-- See :help vim.diagnostic.Opts
	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = diagnostic.message,
					[vim.diagnostic.severity.WARN] = diagnostic.message,
					[vim.diagnostic.severity.INFO] = diagnostic.message,
					[vim.diagnostic.severity.HINT] = diagnostic.message,
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
	})

	-- Format on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		group = vim.api.nvim_create_augroup("Format on save", { clear = true }),
		callback = function(args)
			if client.name == "copilot" then -- Copilot does not need format on save
			else -- Fallback to LSP default formatter
				require("conform").format({ bufnr = args.buf })
				-- vim.lsp.buf.format { async = false }
			end
		end,
	})
end)

-- Configure Mason auto install language servers
require("mason").setup({})
local servers = {
	-- Configure nix
	nil_ls = function()
		require("lspconfig").nil_ls.setup({
			settings = {
				["nil"] = {
					formatting = { command = { "nixpkgs-fmt" } },
				},
			},
		})
	end,

	-- -- Disable lspconfig for rust since we use rustaceanvim
	-- rust_analyzer = function() end,

	-- Configure clangd (for C/C++)
	clangd = function()
		require("lspconfig").clangd.setup({})
	end,

	-- Configure Python
	pyright = function()
		require("lspconfig").pyright.setup({})
	end,

	-- Configure Lua
	lua_ls = function()
		require("lspconfig").lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
				},
			},
		})
	end,

	-- Add eslint fix all on save
	eslint = function()
		require("lspconfig").eslint.setup({
			on_attach = function(client, _)
				client.server_capabilities.documentFormattingProvider = true
			end,
		})
	end,
}
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
	handlers = {
		function(server_name)
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local server = servers[server_name] or {}
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for ts_ls)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

lsp.setup()
