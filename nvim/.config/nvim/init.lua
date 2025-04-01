-- Enable faster startup by caching Lua modules
vim.loader.enable()

-- Load list of disabled built-in plugins (from env var)
vim.g.disabled_plugins = vim.split(os.getenv 'DISABLED_PLUGINS' or '', '')

-- Core configuration setup
require 'core'                -- Sets leader key and other base settings
require 'core.lazy-bootstrap' -- Ensures Lazy.nvim is installed

-- Load user-defined options and keymaps
require 'user.options' -- Sets editor behavior (tabs, line numbers, etc.)
require 'user.keymaps' -- Custom key mappings

-- Setup Lazy.nvim and load plugins from 'plugins/' directory
require('lazy').setup('plugins', require('user.lazy').config)

-- Now that plugins are loaded, set the colorscheme
local pref_file = vim.fn.stdpath('config') .. '/colorscheme.txt'
local colorscheme = 'default'
if vim.fn.filereadable(pref_file) == 1 then
  colorscheme = vim.fn.readfile(pref_file)[1]
  vim.notify('Loading colorscheme: ' .. colorscheme, vim.log.levels.INFO)
end
local ok, err = pcall(vim.cmd.colorscheme, colorscheme)
if not ok then
  vim.notify('Error loading colorscheme: ' .. err, vim.log.levels.ERROR)
  -- If failed, try to set default
  vim.cmd.colorscheme('default')
end

-- Load custom behaviors after plugin loading
require 'user.autocommands'      -- Autocommands for filetypes/events
require 'user.number-separators' -- Adds separators for numeric readability

-- Shortcut: Quickly quit Neovim without saving
vim.keymap.set('n', '<leader>q', ':qa!<CR>', { noremap = true, silent = true, desc = 'Quit all without saving' })

vim.keymap.set('n', '<leader>tcm', function()
  local themes = vim.fn.getcompletion('', 'color')
  vim.ui.select(themes, { prompt = 'Choose Colorscheme:' }, function(choice)
    if choice then
      -- Apply the colorscheme
      vim.cmd.colorscheme(choice)
      -- Save the choice to a separate file
      local pref_file = vim.fn.stdpath('config') .. '/colorscheme.txt'
      local success = vim.fn.writefile({ choice }, pref_file)
      if success == 0 then
        vim.notify('Colorscheme ' .. choice .. ' saved to ' .. pref_file, vim.log.levels.INFO)
      else
        vim.notify('Failed to save colorscheme preference', vim.log.levels.ERROR)
      end
    end
  end)
end, { desc = 'Colorscheme Action Picker' })
-- Shortcut: Open dynamic colorscheme picker using <leader>tcm
-- vim.keymap.set('n', '<leader>tcm', function()
--   local themes = vim.fn.getcompletion('', 'color')
--   vim.ui.select(themes, { prompt = 'Choose Colorscheme:' }, function(choice)
--     if choice then
--       vim.cmd.colorscheme(choice)
--       -- Get the init.lua file path
--       local config_path = vim.fn.stdpath('config') .. '/init.lua'
--       -- Read the current content
--       local lines = vim.fn.readfile(config_path)
--       local found = false
--       -- Look for existing colorscheme setting and replace it
--       for i, line in ipairs(lines) do
--         if line:match('^vim.cmd.colorscheme') then
--           lines[i] = string.format('vim.cmd.colorscheme("%s")', choice)
--           found = true
--           break
--         end
--       end
--       -- If no existing colorscheme line found, add it after the loader enable line
--       if not found then
--         for i, line in ipairs(lines) do
--           if line:match('vim.loader.enable') then
--             table.insert(lines, i + 1, string.format('vim.cmd.colorscheme("%s")', choice))
--             break
--           end
--         end
--       end
--       -- Write the modified content back
--       vim.fn.writefile(lines, config_path)
--     end
--   end)
-- end, { desc = 'Colorscheme Action Picker' })
-- vim.keymap.set('n', '<leader>tcm', function()
--   local themes = vim.fn.getcompletion('', 'color')
--   vim.ui.select(themes, { prompt = 'Choose Colorscheme:' }, function(choice)
--     if choice then
--       vim.cmd.colorscheme(choice)
--     end
--   end)
-- end, { desc = 'Colorscheme Action Picker' })

-- Always open file tree when launching Neovim
-- vim.api.nvim_create_autocmd('VimEnter', {
--   callback = function()
--     local tree = require('nvim-tree.api').tree
--     vim.schedule(function()
--       tree.open()
--     end)
--   end,
-- })
