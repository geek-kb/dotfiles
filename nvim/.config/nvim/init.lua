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

-- Now safe to run code dependent on loaded plugins
-- require('user.tree').setup_dynamic_width()

-- Load custom behaviors after plugin loading
require 'user.autocommands'      -- Autocommands for filetypes/events
require 'user.number-separators' -- Adds separators for numeric readability

-- Shortcut: Quickly quit Neovim without saving
vim.keymap.set('n', '<leader>q', ':qa!<CR>', { noremap = true, silent = true, desc = 'Quit all without saving' })

-- Shortcut: Open dynamic colorscheme picker using <leader>tcm
vim.keymap.set('n', '<leader>tcm', function()
  local themes = vim.fn.getcompletion('', 'color')
  vim.ui.select(themes, { prompt = 'Choose Colorscheme:' }, function(choice)
    if choice then
      vim.cmd.colorscheme(choice)
    end
  end)
end, { desc = 'Colorscheme Action Picker' })

-- Always open file tree when launching Neovim
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local tree = require('nvim-tree.api').tree
    vim.schedule(function()
      tree.open()
    end)
  end,
})
