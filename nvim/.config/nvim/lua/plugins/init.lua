-- Disable Perl and Ruby providers if you don't need them
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

---@class PluginSpec[]
--- Plugin specifications for Lazy.nvim plugin manager
--- This fil    opts = {
      model = 'claude-3    opts =    opts = {
      -- Use default model (don't sp    opts = {
      model = 'claude-3.5-sonnet',
      question_header = '  User ',
      answer_header = '  Copilot ',
      error_header = '  Error ',
      
      -- Auto-context configuration
      resources = { 'selection', 'buffers:visible' }, -- Automatically include selection + visible buffers
      selection = 'visual', -- Use visual selection as default
      auto_insert_mode = true, -- Enter insert mode when opening chat
      highlight_selection = true, -- Highlight what's being shared
      
      -- Better UX settings
      window = {
        layout = 'vertical',
        width = 0.4, -- 40% of screen width
        title = '🤖 Copilot Chat',
      },
      
      -- Enhanced mappings for easier code application
      mappings = {
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        show_diff = {
          normal = 'gd',
          full_diff = true, -- Show full diff for better context
        },
        jump_to_diff = {
          normal = 'gj',
        },
        yank_diff = {
          normal = 'gy',
          register = '+', -- Use system clipboard
        },
        quickfix_diffs = {
          normal = 'gqd',
        },
        -- Add a custom apply all diffs mapping
        apply_in_replace_mode = {
          normal = '<C-a>',
        },
      },
    },to let CopilotChat choose)
      question_header = '  User ',
      answer_header = '  Copilot ',
      error_header = '  Error ',
      -- Agent mode configuration
      auto_follow_cursor = false,
      show_help = true,
      -- Prompts for different agent modes
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
          callback = function(response, source)
            -- Optionally handle the response
          end,
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Please generate tests for my code.",
        },
        FixDiagnostic = {
          prompt = "/COPILOT_GENERATE Please assist with the following diagnostic issue in file:",
          selection = function(source)
            return require("CopilotChat.select").diagnostics(source)
          end,
        },
        Commit = {
          prompt = "/COPILOT_GENERATE Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt = "/COPILOT_GENERATE Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source, true)
          end,
        },
      },
    },   model = 'gpt-4o',  -- Use a supported OpenAI model
      question_header = '  User ',
      answer_header = '  Copilot ',
      error_header = '  Error ',
      -- Add debug settings
      debug = false,
      log_level = 'info',
      -- Ensure proper timeout settings
      timeout = 30000,
    },net',
      question_header = '  User ',
      answer_header = '  Copilot ',
      error_header = '  Error ',
      mappings = {
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-m>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        yank_diff = {
          normal = 'gy',
          register = '"',
        },
        show_diff = {
          normal = 'gd'
        },
        show_system_prompt = {
          normal = 'gp'
        },
        show_user_selection = {
          normal = 'gs'
        },
      }
    },ains the core plugin configurations for Neovim
local M = {
  {
    'nvim-lua/plenary.nvim',
    cmd = {
      'PlenaryBustedFile',
      'PlenaryBustedDirectory',
    },
    keys = {
      { '<leader>tf', '<cmd>PlenaryBustedFile %<CR>', mode = 'n' },
    },
  },
  {
    'milisims/nvim-luaref',
    ft = 'lua',
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'chr4/nginx.vim',
    ft = 'nginx',
  },
  {
    'yorickpeterse/nvim-pqf',
    opts = {},
    event = 'QuickFixCmdPre',
    -- ft = 'qf',
  },
  {
    'tommcdo/vim-lister',
    ft = 'qf',
    cmd = { 'Qfilter', 'Qgrep' },
  }, -- Qfilter and Qgrep on Quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },
  {
    'junegunn/vim-easy-align',
    keys = { { 'ga', '<Plug>(EasyAlign)', mode = { 'v', 'n' } } },
  },
  {
    'AndrewRadev/switch.vim',
    keys = {
      { 'gs', nil, { 'n', 'v' }, desc = 'Switch' },
    },
    config = function()
      local fk = [=[\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>]=]
      local sk = [=[\<\(\u\l\+\)\(\u\l\+\)\+\>]=]
      local tk = [=[\<\(\l\+\)\(_\l\+\)\+\>]=]
      local fok = [=[\<\(\u\+\)\(_\u\+\)\+\>]=]
      local folk = [=[\<\(\l\+\)\(\-\l\+\)\+\>]=]
      local fik = [=[\<\(\l\+\)\(\.\l\+\)\+\>]=]
      vim.g['switch_custom_definitions'] = {
        vim.fn['switch#NormalizedCaseWords'] { 'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday' },
        vim.fn['switch#NormalizedCase'] { 'yes', 'no' },
        vim.fn['switch#NormalizedCase'] { 'on', 'off' },
        vim.fn['switch#NormalizedCase'] { 'left', 'right' },
        vim.fn['switch#NormalizedCase'] { 'up', 'down' },
        vim.fn['switch#NormalizedCase'] { 'enable', 'disable' },
        vim.fn['switch#NormalizedCase'] { 'Always', 'Never' },
        vim.fn['switch#NormalizedCase'] { 'debug', 'info', 'warning', 'error', 'critical' },
        { '==', '!=', '~=' },
        {
          [fk] = [=[\=toupper(submatch(1)) . submatch(2)]=],
          [sk] = [=[\=tolower(substitute(submatch(0), '\(\l\)\(\u\)', '\1_\2', 'g'))]=],
          [tk] = [=[\U\0]=],
          [fok] = [=[\=tolower(substitute(submatch(0), '_', '-', 'g'))]=],
          [folk] = [=[\=substitute(submatch(0), '-', '.', 'g')]=],
          [fik] = [=[\=substitute(submatch(0), '\.\(\l\)', '\u\1', 'g')]=],
        },
      }
    end,
    init = function()
      local custom_switches = require('user.utils').augroup 'CustomSwitches'
      vim.api.nvim_create_autocmd('FileType', {
        group = custom_switches,
        pattern = { 'gitrebase' },
        callback = function()
          vim.b['switch_custom_definitions'] = {
            { 'pick', 'reword', 'edit', 'squash', 'fixup', 'exec', 'drop' },
          }
        end,
      })
      -- (un)check markdown buxes
      vim.api.nvim_create_autocmd('FileType', {
        group = custom_switches,
        pattern = { 'markdown' },
        callback = function()
          local fk = [=[\v^(\s*[*+-] )?\[ \]]=]
          local sk = [=[\v^(\s*[*+-] )?\[x\]]=]
          local tk = [=[\v^(\s*[*+-] )?\[-\]]=]
          local fok = [=[\v^(\s*\d+\. )?\[ \]]=]
          local fik = [=[\v^(\s*\d+\. )?\[x\]]=]
          local sik = [=[\v^(\s*\d+\. )?\[-\]]=]
          vim.b['switch_custom_definitions'] = {
            {
              [fk] = [=[\1[x]]=],
              [sk] = [=[\1[-]]=],
              [tk] = [=[\1[ ]]=],
            },
            {
              [fok] = [=[\1[x]]=],
              [fik] = [=[\1[-]]=],
              [sik] = [=[\1[ ]]=],
            },
          }
        end,
      })
    end,
  },
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', '<Plug>(leap-forward-to)' },
      { 'S', '<Plug>(leap-backward-to)' },
    },
  },
  {
    'axelvc/template-string.nvim',
    ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'python' },
    event = 'InsertEnter',
    config = true,
  },
  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      { 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]] },
      { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]] },
      { '*', [[*<Cmd>lua require('hlslens').start()<CR>N]] },
      { '#', [[#<Cmd>lua require('hlslens').start()<CR>n]] },
      { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    event = 'CmdlineEnter',
    opts = {},
  },
  {
    'machakann/vim-swap',
    keys = {
      { '<leader>sw', '<Plug>(swap-interactive)', mode = { 'n', 'v' } },
      { 'g<', '<Plug>(swap-prev)' },
      { 'g>', '<Plug>(swap-next)' },
    },
    init = function()
      vim.g.swap_no_default_key_mappings = true
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    event = { 'InsertEnter' },
    config = function()
      vim.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'
      require('copilot').setup {
        copilot_node_command = 'node',
        filetypes = { python = true, ['*'] = true },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-l>',
          },
        },
        suggestion = {
          auto_trigger = true,
          enabled = true,
          keymap = {
            accept = '<M-Enter>',
          },
        },
      }
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cmd = {
      'CopilotChat',
      'CopilotChatAgents',
      'CopilotChatClose',
      'CopilotChatCommit',
      'CopilotChatCommitStaged',
      'CopilotChatDebugInfo',
      'CopilotChatDocs',
      'CopilotChatExplain',
      'CopilotChatFix',
      'CopilotChatFixDiagnostic',
      'CopilotChatLoad',
      'CopilotChatModels',
      'CopilotChatOpen',
      'CopilotChatOptimize',
      'CopilotChatReset',
      'CopilotChatReview',
      'CopilotChatSave',
      'CopilotChatStop',
      'CopilotChatTests',
      'CopilotChatToggle',
    },
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'claude-3.5-sonnet',
      question_header = '  User ',
      answer_header = '  Copilot ',
      error_header = '  Error ',
    },
    config = function(_, opts)
      -- Create necessary directories
      local state_dir = vim.fn.stdpath 'state'
      local copilot_dir = state_dir .. '/copilot'
      if vim.fn.isdirectory(copilot_dir) == 0 then
        vim.fn.mkdir(copilot_dir, 'p')
      end

      local chat = require 'CopilotChat'
      chat.setup(opts)

      -- Override CopilotChat window behavior more aggressively
      vim.api.nvim_create_autocmd({'BufEnter', 'FileType'}, {
        pattern = {'copilot-chat', '*copilot*'},
        callback = function(event)
          local bufnr = event.buf
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          
          -- Check if this is a CopilotChat buffer by name or filetype
          if bufname:match('copilot') or vim.bo[bufnr].filetype == 'copilot-chat' then
            -- Debug what buffer we're in
            print("DEBUG: Setting up CopilotChat keymaps for buffer: " .. bufname .. ", filetype: " .. vim.bo[bufnr].filetype)
            
            -- Override with higher priority and nowait
            vim.keymap.set('n', '<C-h>', function()
              print("DEBUG: CopilotChat <C-h> pressed")
              require('smart-splits').move_cursor_left()
            end, {
              buffer = bufnr,
              silent = false,  -- Changed to false for debugging
              nowait = true,
              desc = 'Go to Left Window (CopilotChat override)',
            })
            vim.keymap.set('n', '<C-j>', function()
              print("DEBUG: CopilotChat <C-j> pressed")
              require('smart-splits').move_cursor_down()
            end, {
              buffer = bufnr,
              silent = false,  -- Changed to false for debugging
              nowait = true,
              desc = 'Go to Lower Window (CopilotChat override)',
            })
            vim.keymap.set('n', '<C-k>', function()
              print("DEBUG: CopilotChat <C-k> pressed")
              require('smart-splits').move_cursor_up()
            end, {
              buffer = bufnr,
              silent = false,  -- Changed to false for debugging
              nowait = true,
              desc = 'Go to Upper Window (CopilotChat override)',
            })
            vim.keymap.set('n', '<C-l>', function()
              print("DEBUG: CopilotChat <C-l> pressed - using smart-splits")
              require('smart-splits').move_cursor_right()
            end, {
              buffer = bufnr,
              silent = false,  -- Changed to false for debugging
              nowait = true,
              desc = 'Go to Right Window (CopilotChat override)',
            })
          end
        end,
      })
    end,
    keys = {
      -- Main CopilotChat
      { '<leader>ccc', '<cmd>CopilotChat<CR>', mode = { 'n', 'v' }, desc = 'CopilotChat' },
      { '<leader>ccs', '<cmd>CopilotChatStop<CR>', desc = 'Stop CopilotChat' },
      
      -- Agent mode shortcuts - Updated to use correct commands
      { '<leader>cca', '<cmd>CopilotChatPrompts<CR>', mode = { 'n' }, desc = 'CopilotChat - Select Prompts' },
      { '<leader>cce', '<cmd>CopilotChat /COPILOT_EXPLAIN<CR>', mode = { 'v' }, desc = 'CopilotChat - Explain selection' },
      { '<leader>ccr', '<cmd>CopilotChat /COPILOT_REVIEW<CR>', mode = { 'v' }, desc = 'CopilotChat - Review selection' },
      { '<leader>ccf', '<cmd>CopilotChat /COPILOT_GENERATE<CR>', mode = { 'v' }, desc = 'CopilotChat - Fix selection' },
      { '<leader>cco', '<cmd>CopilotChat Please optimize this code<CR>', mode = { 'v' }, desc = 'CopilotChat - Optimize selection' },
      { '<leader>ccd', '<cmd>CopilotChat Please add documentation for this code<CR>', mode = { 'v' }, desc = 'CopilotChat - Add docs' },
      { '<leader>cct', '<cmd>CopilotChat Please generate tests for this code<CR>', mode = { 'v' }, desc = 'CopilotChat - Generate tests' },
      { '<leader>ccx', '<cmd>CopilotChat Please fix the diagnostics in this file<CR>', desc = 'CopilotChat - Fix diagnostic' },
      { '<leader>ccm', '<cmd>CopilotChat Please write a commit message for this change<CR>', desc = 'CopilotChat - Commit message' },
      { '<leader>ccM', '<cmd>CopilotChat Please write a commit message for the staged changes<CR>', desc = 'CopilotChat - Commit message (staged)' },
    },
  },
}

vim.keymap.set('n', '<leader>z', '<cmd>Lazy<CR>', { silent = true })

return M
