local M = {
  diagnostic_signs = {
    [vim.diagnostic.severity.ERROR] = '✘',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.HINT] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
  },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
}

M.setup = function()
  require('user.lsp.actions').setup()
  require('vim.lsp.log').set_format_func(vim.inspect)
  M.capabilities =
      vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(), M.capabilities or {}, {})

  -- Setup URI error handler to suppress LSP URI errors
  local uri_handler = require('user.lsp.uri_error_handler')
  uri_handler.setup_error_handler()

  -- Diagnostics
  vim.diagnostic.config {
    jump = { float = true },
    signs = { text = M.diagnostic_signs },
    virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
    float = { border = 'rounded', source = 'if_many' },
  }

  ---@diagnostic disable-next-line: missing-fields
  require('mason-lspconfig').setup({
    automatic_installation = true,
    handlers = {
      -- Default handler for all servers
      function(server_name)
        require('lspconfig')[server_name].setup({
          capabilities = M.capabilities,
        })
      end,
      -- Custom handlers for servers that need special configuration
      ['jsonls'] = function()
        require('lspconfig').jsonls.setup({
          capabilities = M.capabilities,
          settings = {
            json = {
              trace = { server = 'on' },
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        })
      end,
      ['pyright'] = function()
        require('lspconfig').pyright.setup({
          capabilities = M.capabilities,
          settings = {
            organizeimports = { provider = 'isort' },
          },
        })
      end,
      ['lua_ls'] = function()
        require('lspconfig').lua_ls.setup({
          capabilities = M.capabilities,
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              completion = { callSnippet = 'Replace' },
              hint = { enable = true },
              diagnostics = {
                disable = { 'undefined-global' },
                globals = { 'vim' },
              },
            },
          },
        })
      end,
      ['terraformls'] = function()
        require('lspconfig').terraformls.setup({
          capabilities = M.capabilities,
          on_attach = function(client)
            require('treesitter-terraform-doc').setup({})
            client.server_capabilities.semanticTokensProvider = {}
            vim.o.commentstring = '# %s'
          end,
        })
      end,
      ['helm_ls'] = function()
        require('lspconfig').helm_ls.setup({
          capabilities = M.capabilities,
          filetypes = { 'helm', 'gotmpl' },
          settings = {},
        })
      end,
    },
  })
  -- Remove the separate servers.setup call since everything is handled by mason-lspconfig now

  -- on attach
  local on_attach_aug = vim.api.nvim_create_augroup('UserLspAttach', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = on_attach_aug,
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local bufnr = ev.buf
      require 'user.lsp.keymaps' (bufnr)
      if client and client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
      end
    end,
  })
end

return M
