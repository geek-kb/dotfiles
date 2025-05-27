-- Set up mermaid filetype options
vim.bo.filetype = 'mermaid'

-- Optional: Add any mermaid-specific settings
vim.bo.commentstring = '%%s'

-- Ensure the filetype is set for .mmd files
vim.cmd [[autocmd BufRead,BufNewFile *.mmd set filetype=mermaid]]
