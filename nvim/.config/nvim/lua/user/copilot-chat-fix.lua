-- CopilotChat <C-l> fix
-- This creates a global <C-l> mapping that's aware of CopilotChat context

local M = {}

local function is_copilot_chat_buffer()
  local bufname = vim.api.nvim_buf_get_name(0)
  local filetype = vim.bo.filetype
  local buftype = vim.bo.buftype
  
  return bufname:match('copilot') ~= nil
    or filetype == 'copilot-chat'
    or filetype:match('copilot') ~= nil
    or (buftype == 'nofile' and bufname:match('copilot'))
end

local function smart_ctrl_l()
  -- Use smart-splits for non-CopilotChat buffers
  require('smart-splits').move_cursor_right()
end

function M.setup()
  -- Set up the mapping after a delay to ensure it overrides everything
  vim.defer_fn(function()
    -- Override the global <C-l> mapping with our smart version
    vim.keymap.set('n', '<C-l>', smart_ctrl_l, {
      desc = 'Smart <C-l> - CopilotChat aware window navigation',
      silent = true,
      nowait = true,
    })
  end, 100)  -- Small delay to load after other plugins
  
  -- Set up buffer-specific overrides for CopilotChat buffers
  vim.api.nvim_create_autocmd({'BufEnter', 'WinEnter'}, {
    pattern = '*',
    callback = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname:match('copilot') then
        local bufnr = vim.api.nvim_get_current_buf()
        
        -- Override <C-l> with smart window navigation
        vim.keymap.set('n', '<C-l>', function()
          -- Get current window info
          local current_winnr = vim.fn.winnr()
          
          -- Try to move right
          vim.cmd('wincmd l')
          
          -- Check if we actually moved to a different window
          local new_winnr = vim.fn.winnr()
          
          if new_winnr == current_winnr then
            -- We didn't move (no window to the right), so move left instead
            vim.cmd('wincmd h')
          end
        end, {
          buffer = bufnr,
          silent = true,
          nowait = true,
          desc = 'Smart window navigation for CopilotChat',
        })
        
        -- Also override in insert mode
        vim.keymap.set('i', '<C-l>', function()
          -- Exit insert mode and move to right window
          vim.cmd('stopinsert')
          vim.cmd('wincmd l')
        end, {
          buffer = bufnr,
          silent = true,
          nowait = true,
          desc = 'Move to right window from insert mode (CopilotChat)',
        })
        
        -- Also override in terminal mode
        vim.keymap.set('t', '<C-l>', function()
          vim.cmd('wincmd l')
        end, {
          buffer = bufnr,
          silent = true,
          nowait = true,
          desc = 'Move to right window from terminal mode (CopilotChat)',
        })
      end
    end,
  })
end

return M
