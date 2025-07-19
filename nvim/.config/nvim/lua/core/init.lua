function _G.put_text(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, '\n'), '\n')
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end

function _G.P(v, r)
  if r then
    print(vim.inspect(v))
  else
    vim.notify(vim.inspect(v), vim.log.levels.WARN, {
      title = 'P debug',
      icon = '✎',
    })
  end
  return v
end

local original_vim_print = vim.print
vim.print = function(...)
  local str = type(...) == 'table' and vim.inspect(...) or ...
  original_vim_print(str)
end

---Write a temporary file with specified options
---@param opts? {should_delete?: boolean, ft?: string, new?: boolean, vertical?: boolean}
---@return string tmp The path to the temporary file
function _G.tmp_write(opts)
  opts = opts or {}
  local final_opts = vim.tbl_deep_extend('force', {
    should_delete = true,
    ft = nil,
    new = true,
    vertical = false,
  }, opts)

  local tmp = vim.fn.tempname()

  if final_opts.new then
    vim.cmd(final_opts.vertical and 'vnew' or 'new')
  end

  if final_opts.ft then
    local extension = require('user.utils').filetype_to_extension[final_opts.ft] or final_opts.ft
    vim.bo.filetype = final_opts.ft
    tmp = tmp .. '.' .. extension
  end

  vim.cmd('write ' .. vim.fn.fnameescape(tmp))
  vim.cmd 'edit'

  if final_opts.should_delete then
    vim.api.nvim_create_autocmd('VimLeavePre', {
      buffer = 0,
      callback = function()
        vim.fn.delete(tmp)
      end,
    })
  end
  return tmp
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Quietly log LSP attachment instead of printing
    if vim.lsp.log and vim.lsp.log.info then
      vim.lsp.log.info('LSP Client attached: ' .. client.name)
    end
  end,
})
--vim.lsp.handlers['workspace/configuration'] = function(err, result, context, config)
--  if err then
--    print('workspace/configuration error:', vim.inspect(err))
--  else
--    print('workspace/configuration result:', vim.inspect(result))
--  end
--
--  -- Respond with default configurations if necessary
--  local default_config = {
--    yaml = {
--      schemas = {
--        kubernetes = '*.yaml',
--      },
--    },
--  }
--
--  return default_config
--end
