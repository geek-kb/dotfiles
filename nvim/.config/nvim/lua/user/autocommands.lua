-- user/autocommands.lua

local utils = require 'user.utils'
local autocmd = vim.api.nvim_create_autocmd
local augroup = utils.augroup
local bit = require 'bit'

-- Reload file on external changes
local reload_file_group = augroup 'ReloadFile'
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = reload_file_group,
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

autocmd('FileChangedShellPost', {
  desc = 'Reload when the file is changed outside of Neovim',
  group = reload_file_group,
  callback = function()
    vim.notify('File changed, reloading the buffer', vim.log.levels.WARN)
  end,
})

-- Startup time info and post-lazy setup
local first_load = augroup 'first_load'
autocmd('UIEnter', {
  desc = 'Print startup time output',
  group = first_load,
  pattern = '*',
  once = true,
  callback = function()
    vim.defer_fn(function()
      if vim.fn.filereadable 'startuptime.txt' == 1 then
        local tail = vim.system({ 'tail', '-n3', 'startuptime.txt' }, { text = true }):wait().stdout
        vim.notify(tail)
        return vim.fn.delete 'startuptime.txt'
      else
        return false
      end
    end, 1500)
  end,
})

autocmd('User', {
  desc = 'Setup user menu after lazy loads',
  group = first_load,
  pattern = 'VeryLazy',
  callback = function()
    require('user.menu').setup()
  end,
})

-- Buffer-local behavior for certain filetypes
local buffer_settings = augroup 'buffer_settings'
autocmd('FileType', {
  desc = 'Set q to quit for specific filetypes',
  group = buffer_settings,
  pattern = {
    'PlenaryTestPopup', 'checkhealth', 'help', 'lspinfo', 'man', 'neotest-output',
    'neotest-output-panel', 'neotest-summary', 'netrw', 'notify', 'qf',
    'spectre_panel', 'startuptime', 'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

autocmd('FileType', {
  pattern = 'cmp_docs',
  group = buffer_settings,
  callback = function()
    vim.treesitter.start(0, 'markdown')
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = buffer_settings,
  callback = function()
    pcall(vim.highlight.on_yank, { higroup = 'IncSearch', timeout = 200 })
  end,
})

autocmd('VimResized', {
  group = buffer_settings,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

autocmd('BufReadPost', {
  desc = 'Restore last cursor position',
  group = buffer_settings,
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.schedule(function()
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
        vim.cmd('normal! zv')
      end)
    end
  end,
})

-- Special case filetype behaviors
local special_filetypes = augroup 'SpecialFiletype'
autocmd('FileType', {
  group = special_filetypes,
  pattern = 'json',
  command = [[syntax match Comment +\/\/.\+$+]],
})
autocmd('FileType', {
  group = special_filetypes,
  pattern = 'javascript',
  command = 'set iskeyword+=-',
})
autocmd('FileType', {
  group = special_filetypes,
  pattern = 'nginx',
  command = 'setlocal iskeyword+=$',
})

-- Auto-open quickfix/location windows
local quickfix_au = augroup 'QuickFix'
autocmd('QuickFixCmdPost', {
  desc = 'Open location list',
  group = quickfix_au,
  pattern = 'l*',
  command = 'lopen',
})
autocmd('QuickFixCmdPost', {
  desc = 'Open quickfix list',
  group = quickfix_au,
  pattern = [[[^l]*]],
  command = 'copen',
})

-- Terminal-specific behavior
local term_au = augroup 'ItaiTerm'
autocmd('TermOpen', {
  group = term_au,
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd.startinsert()
  end,
})

-- Make shell scripts executable on write
local CustomSettingsGroup = augroup 'CustomSettingsGroup'
autocmd('BufWritePost', {
  group = CustomSettingsGroup,
  desc = 'Make script executable if it starts with shebang',
  pattern = '*',
  callback = function(args)
    local shebang = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]
    if not shebang or not shebang:match '^#!.+' then
      return
    end
    local filename = vim.api.nvim_buf_get_name(args.buf)
    local fileinfo = vim.uv.fs_stat(filename)
    if not fileinfo or bit.band(fileinfo.mode - 32768, 0x40) ~= 0 then
      return
    end
    vim.notify 'File made executable'
    vim.uv.fs_chmod(filename, bit.bor(fileinfo.mode, 493))
  end,
})

-- Titleize header with = or -
vim.api.nvim_create_user_command('Titleize', function(opts)
  local title_char = '-'
  if opts.args ~= '' then
    title_char = opts.args
  end
  local current_line = vim.api.nvim_get_current_line()
  local indent = string.match(current_line, '^%s*')
  current_line = vim.trim(current_line)
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_del_current_line()
  local top_bottom = indent .. title_char:rep(#current_line + 6)
  vim.api.nvim_buf_set_lines(0, r - 1, r - 1, false, {
    top_bottom,
    indent .. title_char:rep(2) .. ' ' .. current_line .. ' ' .. title_char:rep(2),
    top_bottom,
  })
end, { nargs = '?' })

---- Auto-resize nvim-tree on window resize
--vim.api.nvim_create_autocmd({ "VimResized" }, {
--  desc = "Resize nvim-tree if nvim window got resized",
--  group = vim.api.nvim_create_augroup("NvimTreeResize", { clear = true }),
--  callback = function()
--    local percentage = 15 -- Adjust the percentage based on your preference
--
--    local ratio = percentage / 100
--    local width = math.floor(vim.go.columns * ratio) -- Calculate the width based on Neovim's current window size
--    -- Resize nvim-tree window
--    vim.cmd("tabdo NvimTreeResize " .. width)
--  end,
--})

-- Auto-manage nvim-tree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Open nvim-tree on startup when no file is specified, close it when file is specified",
  group = vim.api.nvim_create_augroup("NvimTreeStartup", { clear = true }),
  callback = function()
    vim.schedule(function()
      local args = vim.fn.argv()
      if #args == 0 then
        pcall(vim.cmd, "NvimTreeOpen")
      else
        pcall(vim.cmd, "NvimTreeClose")
      end
    end)
  end,
})

-- Auto-resize nvim-tree on window resize
vim.api.nvim_create_autocmd({ "VimResized" }, {
  desc = "Resize nvim-tree if nvim window got resized",
  group = vim.api.nvim_create_augroup("NvimTreeResize", { clear = true }),
  callback = function()
    local percentage = 15 -- Adjust the percentage based on your preference
    local ratio = percentage / 100
    local width = math.floor(vim.go.columns * ratio)
    vim.cmd("tabdo NvimTreeResize " .. width)
  end,
})
