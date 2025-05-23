local sort_current = 1
local SORT_METHODS = {
  'name',
  'case_sensitive',
  'modification_time',
  'extension',
}

local function on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local cycle_sort = function()
    if sort_current >= #SORT_METHODS then
      sort_current = 1
    else
      sort_current = sort_current + 1
    end
    api.tree.reload()
    require('user.utils').pretty_print('Sort Method: ' .. SORT_METHODS[sort_current])
  end

  -- mark operation
  local mark_move_j = function()
    api.marks.toggle()
    vim.cmd 'norm j'
  end
  local mark_move_k = function()
    api.marks.toggle()
    vim.cmd 'norm k'
  end

  -- marked files operation
  local mark_trash = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    vim.ui.input({ prompt = string.format('Trash %s files? [y/n] ', #marks) }, function(input)
      if input == 'y' then
        for _, node in ipairs(marks) do
          api.fs.trash(node)
        end
        api.marks.clear()
        api.tree.reload()
      end
    end)
  end
  local mark_remove = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    vim.ui.input({ prompt = string.format('Remove/Delete %s files? [y/n] ', #marks) }, function(input)
      if input == 'y' then
        for _, node in ipairs(marks) do
          api.fs.remove(node)
        end
        api.marks.clear()
        api.tree.reload()
      end
    end)
  end
  local mark_copy = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    for _, node in pairs(marks) do
      api.fs.copy.node(node)
    end
    api.marks.clear()
    api.tree.reload()
  end
  local mark_cut = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    for _, node in pairs(marks) do
      api.fs.cut(node)
    end
    api.marks.clear()
    api.tree.reload()
  end

  -- lefty/righty
  local lefty = function()
    local node_at_cursor = api.tree.get_node_under_cursor()
    if node_at_cursor.nodes and node_at_cursor.open then
      api.node.open.edit()
    else
      api.node.navigate.parent()
    end
  end
  local righty = function()
    local node_at_cursor = api.tree.get_node_under_cursor()
    if node_at_cursor.nodes and not node_at_cursor.open then
      api.node.open.edit()
    end
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 'x', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')
  vim.keymap.set('n', 'i', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', 'cd', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', 'T', cycle_sort, opts 'Cycle Sort')
  vim.keymap.del('n', 's', { buffer = bufnr })
  vim.keymap.del('n', '<C-e>', { buffer = bufnr })
  vim.keymap.del('n', 'bd', { buffer = bufnr })

  vim.keymap.set('n', 'h', lefty, opts 'Left')
  vim.keymap.set('n', '<Left>', lefty, opts 'Left')
  vim.keymap.set('n', '<Right>', righty, opts 'Right')
  vim.keymap.set('n', 'l', righty, opts 'Right')

  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'J', mark_move_j, opts 'Toggle Bookmark Down')
  vim.keymap.set('n', 'K', mark_move_k, opts 'Toggle Bookmark Up')

  vim.keymap.set('n', 'dd', mark_cut, opts 'Cut File(s)')
  vim.keymap.set('n', 'df', mark_trash, opts 'Trash File(s)')
  vim.keymap.set('n', 'dF', mark_remove, opts 'Remove File(s)')
  vim.keymap.set('n', 'yy', mark_copy, opts 'Copy File(s)')

  vim.keymap.set('n', 'mv', api.marks.bulk.move, opts 'Move Bookmarked')

  local function move_file_to()
    local node = api.tree.get_node_under_cursor()
    local file_src = node['absolute_path']
    local file_out = vim.fn.input('MOVE TO: ', file_src, 'file')
    local dir = vim.fn.fnamemodify(file_out, ':h')
    vim.system({ 'mkdir', '-p', dir }, { text = true }):wait()
    vim.system({ 'mv', file_src, file_out }, { text = true }):wait()
  end
  vim.keymap.set('n', 'r', move_file_to, opts 'Move File To')

  -- Copy absolute file path to clipboard
  local function copy_absolute_path()
    local node = api.tree.get_node_under_cursor()
    if not node or not node.absolute_path then
      vim.notify('No file selected', vim.log.levels.WARN)
      return
    end
    vim.fn.setreg('+', node.absolute_path)
    vim.notify('Copied full path: ' .. node.absolute_path)
  end
  local function copy_relative_path()
    local node = api.tree.get_node_under_cursor()
    if not node or not node.absolute_path then
      vim.notify('No file selected', vim.log.levels.WARN)
      return
    end
    local path = vim.fn.fnamemodify(node.absolute_path, ':.')
    vim.fn.setreg('+', path)
    vim.notify('Copied relative path: ' .. path)
  end
  -- Copy file name only
  local function copy_filename()
    local node = api.tree.get_node_under_cursor()
    if not node or not node.name then
      vim.notify('No file selected', vim.log.levels.WARN)
      return
    end
    vim.fn.setreg('+', node.name)
    vim.notify('Copied file name: ' .. node.name)
  end

  -- Copy directory path of selected node
  local function copy_dir_path()
    local node = api.tree.get_node_under_cursor()
    if not node or not node.absolute_path then
      vim.notify('No file selected', vim.log.levels.WARN)
      return
    end
    local dir = vim.fn.fnamemodify(node.absolute_path, ':h')
    vim.fn.setreg('+', dir)
    vim.notify('Copied directory path: ' .. dir)
  end
  vim.keymap.set('n', '<leader>cfa', copy_absolute_path, opts 'Copy Absolute Path')
  vim.keymap.set('n', '<leader>cfp', copy_relative_path, opts 'Copy Relative Path')
  vim.keymap.set('n', '<leader>cfn', copy_filename, opts 'Copy File Name')
  vim.keymap.set('n', '<leader>cfd', copy_dir_path, opts 'Copy Dir Name')
end

local M = {
  'nvim-tree/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFocus', 'NvimTreeRefresh' },
  keys = { '<c-o>', '<leader>v' },
}

M.keys = {
  { '<leader>v', ':lua require("nvim-tree.api").tree.find_file { open = true, focus = true }<cr>', silent = true, desc = 'Open Tree under current file' },
  { '<c-o>', ':lua require("nvim-tree.api").tree.toggle()<cr>', silent = true, desc = 'Open Tree' },
}

M.config = function()
  local nvim_tree = require 'nvim-tree'
  local api = require 'nvim-tree.api'

  local sort_by = function()
    return SORT_METHODS[sort_current]
  end

  nvim_tree.setup {
    live_filter = {
      prefix = '[FILTER]: ',
      always_show_folders = false,
    },
    ui = {
      confirm = {
        remove = true,
        trash = false,
      },
    },
    on_attach = on_attach,
    sort = { sorter = sort_by },
    actions = {
      open_file = {
        resize_window = false,
      },
    },
    disable_netrw = false,
    git = {
      enable = false,
      ignore = true,
    },
    hijack_cursor = true,
    select_prompts = true,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    open_on_tab = false,
    reload_on_bufenter = false,
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = false,
    },
    -- In order to configure the tree to auto resize itself based on the longest file in the tree
    -- change the adaptive_size to true
    -- and set the max width to 0
    view = {
      side = 'left',
      width = {
        --        min = 30,
        max = 0,
        padding = 1,
      },
      adaptive_size = true,
      float = {
        enable = false,
      },
    },
    filters = {
      dotfiles = false,
      custom = { '\\^.git' },
    },
  }

  api.events.subscribe(api.events.Event.FileCreated, function(file)
    vim.cmd('edit ' .. file.fname)

    local prev = { new_name = '', old_name = '' }
    vim.api.nvim_create_autocmd('User', {
      pattern = 'NvimTreeSetup',
      callback = function()
        local events = require('nvim-tree.api').events
        events.subscribe(events.Event.NodeRenamed, function(data)
          if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
            prev = data
            if _G.Snacks and _G.Snacks.rename and _G.Snacks.rename.on_rename_file then
              _G.Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
            require('nvim-tree.api').tree.reload()
          end
        end)
      end,
    })
  end)
end

return M
