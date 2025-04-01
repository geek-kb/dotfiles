return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',                    -- required dependency
      'nvim-telescope/telescope-fzf-native.nvim', -- optional native sorter for better performance
      'nvim-telescope/telescope-ui-select.nvim',  -- optional UI enhancement
    },
    cmd = 'Telescope',
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>',                                                        desc = 'Find Files' },
      { '<leader>fH', function() require('telescope.builtin').find_files { cwd = vim.loop.os_homedir() } end, desc = 'Find Files in Home' },

      { '<leader>fg', '<cmd>Telescope live_grep<cr>',                                                         desc = 'Live Grep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>',                                                           desc = 'Buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>',                                                         desc = 'Help Tags' },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          layout_config = {
            horizontal = { preview_width = 0.6 },
          },
        },
        pickers = {
          find_files = {
            hidden = true
          }
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
          }
        }
      }

      -- Load optional extensions
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
    end,
  },
}
