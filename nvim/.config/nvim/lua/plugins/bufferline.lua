return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        show_tab_indicators = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
        enforce_regular_tabs = false,
        custom_filter = function(buf_number, _)
          -- filter out filetypes you don't want to see
          local exclude_ft = { "qf", "fugitive", "git" }
          local ft = vim.bo[buf_number].filetype
          return not vim.tbl_contains(exclude_ft, ft)
        end,
      },
    })
  end,
}
