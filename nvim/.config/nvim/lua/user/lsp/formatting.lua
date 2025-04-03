local M = {}

M.format = function()
  -- You can replace this with your preferred method of formatting.
  -- Example using LSP formatting:
  if vim.lsp.buf.format then
    vim.lsp.buf.format({ async = true })
  else
    -- Fallback to other formatters like null-ls
    vim.notify("No LSP formatting available", vim.log.levels.ERROR)
  end
end

return M
