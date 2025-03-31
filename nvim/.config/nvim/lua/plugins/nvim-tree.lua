-- return {
--   'nvim-tree/nvim-tree.lua',
--   event = 'VeryLazy',
--   config = function()
--     require('nvim-tree').setup({
--       view = {
--         adaptive_size = true, -- Automatically resize tree width to longest filename
--         width = 30,           -- Fallback/default width
--       },
--       renderer = {
--         group_empty = true,
--       },
--       filters = {
--         dotfiles = false,
--       },
--       git = {
--         enable = true,
--       },
--     })
--   end,
-- }
-- require('nvim-tree').setup {
--   view = {
--     width = 40,
--     adaptive_size = false, -- disable dynamic resizing
--   },
-- }
return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 30,
      },
    }
  end,
}
