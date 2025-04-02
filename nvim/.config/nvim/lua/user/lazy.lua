return {
  -- 🎨 Colorscheme Plugins (loaded eagerly for immediate availability)

  {
    'morhetz/gruvbox', -- Classic retro groove color scheme
    name = 'gruvbox',
    lazy = false,      -- Load on startup
    priority = 1000,   -- Ensure it loads before others
  },
  {
    'catppuccin/nvim', -- Warm pastel theme with extensive customization
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup() -- Basic setup for catppuccin
    end,
  },
  {
    'folke/tokyonight.nvim', -- Elegant dark theme
    name = 'tokyonight',
    lazy = false,
    priority = 1000,
  },
  {
    "dstein64/vim-startuptime-colorschemes", -- Preview installed themes in UI
    cmd = { "ColorschemePreview" },          -- Lazy load only when this command is used
  },

  -- ⚙️ Lazy.nvim Configuration

  {
    "LazyVim/LazyVim", -- Base plugin used to configure Lazy (can be your root if using LazyVim)

    config = {
      defaults = {
        cond = function(plugin)
          -- Skip loading if plugin name is in DISABLED_PLUGINS env var
          return not vim.tbl_contains(vim.g.disabled_plugins or {}, plugin.name)
        end,
      },

      change_detection = {
        notify = false, -- Don't show notifications for plugin config changes
      },

      ui = {
        border = 'rounded', -- Rounded UI for plugin dialogs

        custom_keys = {
          -- <localleader>t copies plugin directory to clipboard
          ['<localleader>t'] = function(plugin)
            vim.fn.setreg('+', plugin.dir)
            vim.notify('Copied path to clipboard: ' .. plugin.dir)
          end,
        },
      },

      diff = {
        cmd = 'diffview.nvim', -- Use Diffview for comparing plugin changes
      },

      checker = {
        enabled = false, -- Disable automatic plugin update checks
      },

      performance = {
        rtp = {
          -- Disable unused built-in plugins to improve startup performance
          disabled_plugins = {
            '2html_plugin',
            'getscript',
            'getscriptPlugin',
            'gzip',
            'logipat',
            -- 'man',
            'matchit',
            'matchparen',
            'netrw',
            'netrwFileHandlers',
            'netrwPlugin',
            'netrwSettings',
            'rplugin',
            'rrhelper',
            'shada',
            'spellfile_plugin',
            'tar',
            'tarPlugin',
            'tohtml',
            'tutor',
            'vimball',
            'vimballPlugin',
            'zip',
            'zipPlugin',
          },
        },
      },
    },
  },
}
