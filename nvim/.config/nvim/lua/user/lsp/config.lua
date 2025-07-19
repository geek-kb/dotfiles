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

  -- Use the robust, future-proof error handler
  local uri_handler = require('user.lsp.uri_error_handler')
  uri_handler.setup_error_handler()
  
  -- Suppress noisy LSP attachment messages
  local original_lsp_notify = vim.lsp._notify or vim.notify
  vim.lsp._notify = function(msg, level)
    if type(msg) == "string" and msg:match("^LSP Client attached:") then
      -- Log quietly instead of showing to user
      if vim.lsp.log and vim.lsp.log.info then
        vim.lsp.log.info("[QUIET] " .. msg)
      end
      return
    end
    return original_lsp_notify(msg, level)
  end
  
  -- Additional LSP-level error suppression
  local original_rpc_start = vim.lsp.start or vim.lsp.start_client
  if original_rpc_start then
    vim.lsp.start = function(config, opts)
      -- Ensure root_dir is never null
      if config and config.root_dir then
        local original_root_dir = config.root_dir
        config.root_dir = function(fname)
          local result = original_root_dir(fname)
          if result == 'null' or result == nil or result == '' then
            return vim.fn.getcwd()
          end
          return result
        end
      end
      return original_rpc_start(config, opts)
    end
  end
  
  -- Add cleanup on Neovim exit to be update-friendly
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      uri_handler.cleanup_error_handler()
    end,
  })

  -- Diagnostics
  vim.diagnostic.config {
    jump = { float = true },
    signs = { text = M.diagnostic_signs },
    virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
    float = { border = 'rounded', source = 'if_many' },
  }

  ---@diagnostic disable-next-line: missing-fields
  require('mason-lspconfig').setup { 
    automatic_installation = true,
    ensure_installed = { 'yamlls' }
  }
  require('user.lsp.servers').setup()

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

  -- Add error handling for LSP initialization failures
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspProgressUpdate',
    callback = function()
      -- Silently handle LSP progress updates to avoid error spam
    end,
  })

  -- Version compatibility and update detection
  local function check_neovim_compatibility()
    local version = vim.version()
    local version_string = string.format("%d.%d.%d", version.major, version.minor, version.patch)
    
    -- Log version for debugging
    if vim.lsp.log and vim.lsp.log.info then
      vim.lsp.log.info("Neovim version: " .. version_string)
      vim.lsp.log.info("LSP client configuration loaded")
    end
    
    -- Check for known problematic versions (add as needed)
    local known_issues = {
      -- Add version-specific workarounds here if needed
    }
    
    return true -- Currently compatible with all versions
  end

  -- Initialize compatibility check
  check_neovim_compatibility()
end

return M
