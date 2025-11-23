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
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local content = table.concat(lines, '\n')

        -- For markdown files, extract mermaid code blocks
        local mermaid_content = nil
        if ft == 'markdown' then
          local in_mermaid_block = false
          local mermaid_lines = {}
          
          for _, line in ipairs(lines) do
            if line:match('^```mermaid') then
              in_mermaid_block = true
            elseif line:match('^```') and in_mermaid_block then
              in_mermaid_block = false
            elseif in_mermaid_block then
              table.insert(mermaid_lines, line)
            end
          end
          
          if #mermaid_lines > 0 then
            mermaid_content = table.concat(mermaid_lines, '\n')
            ft = 'mermaid'  -- Change filetype to mermaid for rendering
          end
        end

        -- Use the extracted mermaid content if available
        local render_content = mermaid_content or content
        
        if ft == 'mermaid' and render_content then
          -- Check mermaid-cli installation
          local mmdc_path = vim.fn.trim(vim.fn.system('which mmdc'))
          
          if mmdc_path == '' or vim.v.shell_error ~= 0 then
            vim.notify('mermaid-cli (mmdc) not found. Install with: npm install -g @mermaid-js/mermaid-cli', vim.log.levels.ERROR)
            return
          end

          -- Get current file path and create output path
          local input_file = vim.fn.tempname() .. '.mmd'
          local output_file = vim.fn.expand('%:p:r') .. '.png'

          -- Write content to temporary file
          vim.fn.writefile(vim.split(render_content, '\n'), input_file)

          -- Run mmdc with error output
          local cmd = string.format('%s -i %s -o %s -b transparent 2>&1', mmdc_path, vim.fn.shellescape(input_file), vim.fn.shellescape(output_file))
          
          local output = vim.fn.system(cmd)
          local exit_code = vim.v.shell_error

          -- Check if file was created
          if exit_code == 0 and vim.fn.filereadable(output_file) == 1 then
            vim.notify('Diagram rendered successfully: ' .. output_file, vim.log.levels.INFO)
            vim.fn.jobstart({ 'open', output_file }, { detach = true })
          else
            -- Show the actual mermaid error
            vim.notify('Failed to render diagram. Error: ' .. output, vim.log.levels.ERROR)
          end

          -- Cleanup temp file
          vim.fn.delete(input_file)
        else
          vim.notify('No mermaid diagram found in ' .. ft .. ' file', vim.log.levels.WARN)
        end
      end, {})
    end,
  },
}
