local M = {
  k8s_schemas = {
    {
      name = 'Kubernetes 1.29.9',
      uri = 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.9-standalone-strict/all.json',
    },
  },
  all_schemas = {},
}

M.setup = function(opts)
  local capabilities = opts.capabilities or require('user.lsp.config').capabilities
  
  -- Version-aware setup with fallbacks
  local function setup_yamlls_safe()
    -- Check if yaml-language-server is available
    local yamlls_cmd = vim.fn.executable('yaml-language-server') == 1 and 'yaml-language-server' or nil
    
    if not yamlls_cmd then
      vim.notify('yaml-language-server not found, YAML LSP features disabled', vim.log.levels.WARN)
      return { settings = { yaml = { validate = false } } }
    end

    local config = {
      capabilities = capabilities,
      cmd = { yamlls_cmd, '--stdio' },
      filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
      
      -- Robust root directory detection with null handling
      root_dir = function(fname)
        -- Handle null, empty, or invalid filenames
        if not fname or fname == '' or fname == 'null' or type(fname) ~= 'string' then
          vim.notify('YAML LSP: Invalid filename provided, using current directory', vim.log.levels.DEBUG)
          return vim.fn.getcwd()
        end
        
        -- Check if file actually exists
        if vim.fn.filereadable(fname) == 0 then
          vim.notify('YAML LSP: File not readable: ' .. fname .. ', using current directory', vim.log.levels.DEBUG)
          return vim.fn.getcwd()
        end
        
        local util = require('lspconfig.util')
        return util.find_git_ancestor(fname) 
            or util.find_node_modules_ancestor(fname)
            or util.path.dirname(fname)
            or vim.fn.getcwd()
      end,
      
      -- Enhanced initialization with error handling
      on_init = function(client, initialize_result)
        if client and client.server_capabilities then
          -- Verify server is properly initialized
          vim.defer_fn(function()
            if client:is_stopped() then
              vim.notify('YAML LSP initialization failed, retrying...', vim.log.levels.INFO)
            end
          end, 2000)
        end
      end,
      
      -- Handle attach with URI validation
      on_attach = function(client, bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        
        -- Skip if buffer has no valid name or is a null path
        if not bufname or bufname == '' or bufname:match('null') then
          vim.notify('YAML LSP: Skipping buffer with invalid name', vim.log.levels.DEBUG)
          return
        end
        
        -- Standard LSP keymaps
        if opts.on_attach then
          opts.on_attach(client, bufnr)
        end
      end,
      
      -- Comprehensive settings
      settings = {
        yaml = {
          format = {
            enable = true,
            bracketSpacing = false,
            proseWrap = 'preserve',
            printWidth = 100,
          },
          validate = true,
          completion = true,
          hover = true,
          
          -- Schema configuration with error handling
          schemas = (function()
            local ok, schemastore = pcall(require, 'schemastore')
            if ok then
              return schemastore.yaml.schemas()
            else
              vim.notify('SchemaStore not available, using basic YAML validation', vim.log.levels.INFO)
              return {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose*.yml",
              }
            end
          end)(),
          
          schemaStore = {
            enable = false,
            url = '',
          },
          
          -- Kubernetes-specific settings
          kubernetes = "*",
          customTags = {
            "!Base64 scalar",
            "!Cidr scalar",
            "!GetAZs sequence",
            "!GetAtt scalar",
            "!If sequence",
            "!Join sequence",
            "!Ref scalar",
            "!Sub scalar",
          },
        },
      },
    }

    -- Safe LSP setup with error handling
    local ok, err = pcall(function()
      -- Additional URI error suppression before setup
      local original_rpc_request = vim.lsp.rpc.request
      vim.lsp.rpc.request = function(method, params, callback, notify_reply_callback)
        -- Check for null paths in initialize requests
        if method == 'initialize' and params and params.rootUri then
          if params.rootUri == 'null' or params.rootUri == '' then
            params.rootUri = vim.uri_from_fname(vim.fn.getcwd())
          end
        end
        return original_rpc_request(method, params, callback, notify_reply_callback)
      end
      
      require('lspconfig').yamlls.setup(config)
      
      -- Restore original RPC function after setup
      vim.lsp.rpc.request = original_rpc_request
    end)
    
    if not ok then
      vim.notify('Failed to setup YAML LSP: ' .. tostring(err), vim.log.levels.ERROR)
      return { settings = { yaml = { validate = false } } }
    end
    
    return { settings = config.settings }
  end

  return setup_yamlls_safe()
end

return M
