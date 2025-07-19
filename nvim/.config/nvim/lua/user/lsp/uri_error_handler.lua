-- LSP URI Error Handler - Future-proof solution
-- This module provides robust error handling for LSP URI-related issues
local M = {}

-- Store references to avoid conflicts with updates
local _original_notify = nil
local _error_handler_active = false

-- Specific error pattern matching
local function is_lsp_uri_error(msg)
  if type(msg) ~= "string" then return false end
  
  local patterns = {
    "UriError.*Scheme is missing.*path.*null",
    "Request initialize failed.*UriError",
    "RPC%[Error%].*UriError.*Scheme is missing"
  }
  
  for _, pattern in ipairs(patterns) do
    if msg:match(pattern) then
      return true
    end
  end
  return false
end

-- Check for noisy LSP messages to suppress
local function is_noisy_lsp_message(msg)
  if type(msg) ~= "string" then return false end
  
  local noisy_patterns = {
    "^LSP Client attached:",
    "client:is_stopped is deprecated",
    "client%.is_stopped is deprecated",
    "client:supports_method is deprecated",
    "client%.supports_method is deprecated"
  }
  
  for _, pattern in ipairs(noisy_patterns) do
    if msg:match(pattern) then
      return true
    end
  end
  return false
end

-- Enhanced error suppression with logging
M.setup_error_handler = function()
  if _error_handler_active then return end
  
  _original_notify = _original_notify or vim.notify
  _error_handler_active = true
  
  -- Also intercept vim.schedule errors that contain URI errors
  local original_schedule = vim.schedule
  vim.schedule = function(fn)
    return original_schedule(function()
      local ok, result = pcall(fn)
      if not ok and is_lsp_uri_error(tostring(result)) then
        -- Suppress LSP URI errors in scheduled functions
        pcall(function()
          local log_msg = string.format("[LSP_URI_ERROR_HANDLER] Suppressed scheduled error: %s", tostring(result))
          if vim.lsp.log and vim.lsp.log.debug then
            vim.lsp.log.debug(log_msg)
          end
        end)
        return -- Don't re-raise the error
      elseif not ok then
        error(result) -- Re-raise non-URI errors
      end
      return result
    end)
  end
  
  vim.notify = function(msg, level, opts)
    -- Suppress LSP URI errors
    if is_lsp_uri_error(msg) then
      pcall(function()
        local log_msg = string.format("[LSP_URI_ERROR_HANDLER] Suppressed: %s", msg)
        if vim.lsp.log and vim.lsp.log.debug then
          vim.lsp.log.debug(log_msg)
        end
      end)
      return
    end
    
    -- Suppress noisy LSP messages
    if is_noisy_lsp_message(msg) then
      pcall(function()
        local log_msg = string.format("[LSP_NOISE_FILTER] Suppressed: %s", msg)
        if vim.lsp.log and vim.lsp.log.debug then
          vim.lsp.log.debug(log_msg)
        end
      end)
      return
    end
    
    -- Pass through all other notifications unchanged
    return _original_notify(msg, level, opts)
  end
  
  -- Self-healing: reset if Neovim updates change vim.notify
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      if vim.notify ~= _original_notify and not _error_handler_active then
        -- Neovim might have been updated, re-setup
        M.setup_error_handler()
      end
    end,
    once = true,
  })
end

-- Graceful cleanup for updates
M.cleanup_error_handler = function()
  if _original_notify and _error_handler_active then
    vim.notify = _original_notify
    _error_handler_active = false
  end
end

-- Health check function
M.health_check = function()
  return {
    handler_active = _error_handler_active,
    original_notify_stored = _original_notify ~= nil,
    neovim_version = vim.version(),
  }
end

return M
