local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('lspconfig').yamlls.setup {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        kubernetes = '*.yaml', -- Example schema
      },
      validate = true,
      format = { enable = true },
    },
  },
}
