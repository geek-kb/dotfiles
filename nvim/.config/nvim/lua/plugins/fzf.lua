return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  keys = {
    { '<c-p>',      ':FzfLua files<cr>',                                                              silent = true },
    { '<c-b>',      ':FzfLua buffers<cr>',                                                            silent = true },
    { '<leader>el', ':FzfLua files cwd=' .. vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy') .. '<cr>', silent = true },
    { '<leader>ee', ':FzfLua builtin<cr>',                                                            silent = true },
    { '<leader>hh', ':FzfLua help_tags<cr>',                                                          silent = true },
    { '<leader>i',  ':FzfLua oldfiles<cr>',                                                           silent = true },
    {
      '<C-x><C-f>',
      require('fzf-lua').complete_path,
      mode = 'i',
      silent = true,
      desc = 'Fuzzy complete path',
    },
    {
      '<leader>ccp',
      function()
        local actions = require 'CopilotChat.actions'
        require('CopilotChat.integrations.fzflua').pick(actions.prompt_actions())
      end,
      desc = 'CopilotChat - Prompt actions',
      mode = { 'n', 'v' },
    },
    {
      '<F4>',
      function()
        local utils = require 'fzf-lua.utils'
        local actions = require 'fzf-lua.actions'

        require('fzf-lua').git_branches {
          actions = {
            ['default'] = {
              fn = function(selected, opts)
                actions.git_switch(selected, opts)
                require('user.git').reload_fugitive_index()
              end,
              header = 'switch',
            },
            ['ctrl-s'] = {
              fn = function(selected)
                local branch = vim.trim(selected[1])
                require('user.git').checkout(branch)
              end,
              reload = false,
              header = 'checkout',
            },
            ['ctrl-y'] = {
              fn = function(selected)
                local branch = vim.trim(selected[1])
                vim.fn.setreg('+', branch)
                utils.info('Yanked branch name ' .. branch)
              end,
              reload = false,
              header = 'yank branch name',
            },
            ['ctrl-r'] = {
              fn = function(selected)
                require('fzf-lua.utils').fzf_exit()
                local branch = vim.trim(selected[1])
                vim.defer_fn(function()
                  vim.ui.input({ prompt = 'Rename branch: ', default = branch }, function(new_name)
                    if not new_name or new_name == '' then
                      utils.warn 'Action aborted'
                      return
                    end
                    local toplevel = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true })
                      :wait().stdout)
                    local _, ret, stderr = require('user.utils').get_os_command_output(
                      { 'git', 'branch', '-m', branch, new_name }, toplevel)
                    if ret == 0 then
                      utils.info('Renamed branch ' .. branch .. ' to ' .. new_name)
                    else
                      local msg = string.format('Error when renaming branch: %s. Git returned:\n%s', branch,
                        table.concat(stderr or {}, '\n'))
                      utils.err(msg)
                    end
                  end)
                end, 100)
              end,
              reload = true,
              header = 'rename',
            },
            ['ctrl-x'] = {
              fn = function(selected)
                local branch = vim.trim(selected[1])
                vim.ui.select({ 'Yes', 'No' },
                  { prompt = 'Are you sure you want to delete the branch ' .. branch .. '?' }, function(yes_or_no)
                    if yes_or_no == 'No' then
                      utils.warn 'Action aborted'
                      return
                    end
                    local toplevel = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }, { text = true })
                      :wait()
                      .stdout)
                    local _, ret, stderr = require('user.utils').get_os_command_output({ 'git', 'branch', '-D', branch },
                      toplevel)
                    if ret == 0 then
                      utils.info('Deleted branch ' .. branch)
                      vim.ui.select({ 'Yes', 'No' }, { prompt = 'Delete also from remote?' }, function(yes_or_no_remote)
                        if yes_or_no_remote == 'No' then return end
                        local _, ret_remote, stderr_remote =
                            require('user.utils').get_os_command_output({ 'git', 'push', 'origin', '--delete', branch },
                              toplevel)
                        if ret_remote == 0 then
                          utils.info('Deleted branch ' .. branch .. ' from remote')
                        else
                          local msg = string.format('Error when deleting branch from remote: %s. Git returned:\n%s',
                            branch,
                            table.concat(stderr_remote or {}, '\n'))
                          utils.err(msg)
                        end
                      end)
                    else
                      local msg = string.format('Error when deleting branch: %s. Git returned:\n%s', branch,
                        table.concat(stderr or {}, '\n'))
                      utils.err(msg)
                    end
                  end)
              end,
              reload = true,
              header = 'delete',
            },
          },
          cmd = 'git-branches.zsh',
        }
      end,
    },
    {
      '<leader>/',
      require('fzf-lua').live_grep,
    },
    --    {
    --      '<leader>h',
    --      ':FzfLua files cwd=' .. vim.fn.expand('~') .. '<CR>',
    --      silent = true,
    --      desc = 'Open files from home directory'
    --    },
  },
  cmd = { 'FzfLua', 'ListFilesFromBranch' },
  config = function()
    require('fzf-lua').setup {
      'default-title',
      files = {
        git_icons = true,
      },
      oldfiles = {
        cwd_only = true,
        include_current_session = true,
      },
      grep = {
        multiprocess = true,
        RIPGREP_CONFIG_PATH = vim.env.HOME .. '/.ripgreprc',
        rg_glob = true,
        glob_flag = '--iglob',
        glob_separator = '%s%-%-',
        hidden = true,
      },
      keymap = { fzf = { ['ctrl-q'] = 'select-all+accept' } },
      previewers = {
        builtin = {
          syntax = function(filepath, bufnr, ft)
            if filepath:match("requirements%.txt$") then
              return "text"
            end
            return ft
          end,
        },
      },
    }

    require('fzf-lua').register_ui_select(function(opts, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      h = math.max(min_h, math.min(h, max_h))
      opts.title = opts.title or 'Select'
      return { winopts = { title = opts.title, height = h, width = 0.60, row = 0.40 } }
    end)
  end,
}
