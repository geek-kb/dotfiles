return {
  {
    '3rd/diagram.nvim',
    dependencies = { '3rd/image.nvim' },
    ft = { 'mermaid', 'plantuml', 'd2' },
    cmd = { 'DiagramRender', 'DiagramClear' },
    keys = {
      {
        '<leader>dr',
        function()
          vim.cmd 'DiagramRender'
        end,
        desc = 'Render Diagram',
      },
    },
    config = function()
      local diagram = require 'diagram'

      diagram.setup {
        rendering = {
          backend = 'none',
          enabled = true,
        },
        integrations = {
          mermaid = {
            renderer = 'mmdc',
            options = {
              theme = 'default',
              background = 'transparent',
              scale = 1,
            },
          },
        },
      }

      -- Custom command to render and open the image
      vim.api.nvim_create_user_command('DiagramRender', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
        local renderers = require 'diagram.renderers'

        -- Debug info
        vim.notify('Current filetype: ' .. ft)
        vim.notify('Content to render: ' .. content)

        -- Check mermaid-cli installation
        local mmdc_path = vim.fn.trim(vim.fn.system 'which mmdc')
        vim.notify('mermaid-cli path: ' .. mmdc_path)

        if renderers[ft] and renderers[ft].render then
          -- Get current file path and create output path
          local input_file = vim.fn.tempname() .. '.mmd'
          local output_file = vim.fn.expand '%:p:r' .. '.png'

          -- Write content to temporary file
          vim.fn.writefile(vim.split(content, '\n'), input_file)

          -- Debug paths
          vim.notify('Input file: ' .. input_file)
          vim.notify('Output file: ' .. output_file)

          -- Run mmdc directly
          local cmd = string.format('%s -i %s -o %s', mmdc_path, input_file, output_file)
          vim.notify('Running command: ' .. cmd)

          local output = vim.fn.system(cmd)
          local exit_code = vim.v.shell_error

          -- Debug command output
          vim.notify('Command exit code: ' .. exit_code)
          vim.notify('Command output: ' .. output)

          -- Check if file was created
          if vim.fn.filereadable(output_file) == 1 then
            vim.notify 'PNG file created successfully'
            vim.fn.jobstart({ 'open', output_file }, {
              detach = true,
              on_exit = function(_, code)
                vim.notify('Open command exit code: ' .. code)
              end,
            })
          else
            vim.notify('Failed to create PNG file', vim.log.levels.ERROR)
          end

          -- Cleanup temp file
          vim.fn.delete(input_file)
        else
          vim.notify('No renderer found for filetype: ' .. ft, vim.log.levels.ERROR)
        end
      end, {})
    end,
  },
}
