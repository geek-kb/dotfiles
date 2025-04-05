local M = {}

local function infer_syft_mode(path)
  local fname = vim.fn.fnamemodify(path, ":t")
  local ext = vim.fn.fnamemodify(path, ":e")

  if ext == "json" and fname:match("sbom") then
    return "sbom"
  end

  local binary_exts = { "deb", "rpm", "apk", "tar", "tar.gz", "tgz" }
  for _, e in ipairs(binary_exts) do
    if ext == e then
      return "file"
    end
  end

  return "dir"
end

function M.setup()
  vim.api.nvim_create_user_command("SyftSBOM", function(opts)
    M.generate_sbom(opts)
  end, {
    nargs = "?",
    complete = "file",
    desc = "Generate SBOM using Syft"
  })
end

function M.generate_sbom(args)
  -- Debug print all args
  vim.notify("Syft args: " .. vim.inspect(args), vim.log.levels.INFO)

  local path = args.args

  -- Fallback to nvim-tree
  if not path or path == "" then
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      local node = api.tree.get_node_under_cursor()
      -- Debug print node information
      vim.notify("Node info: " .. vim.inspect(node), vim.log.levels.INFO)
      if node and node.absolute_path then
        path = node.absolute_path
        vim.notify("Got path from nvim-tree: " .. path, vim.log.levels.INFO)
      else
        vim.notify("nvim-tree node under cursor is missing or invalid", vim.log.levels.WARN)
      end
    else
      vim.notify("nvim-tree.api not available", vim.log.levels.WARN)
    end
  end

  -- Fallback to current buffer if no path from nvim-tree
  if not path or path == "" then
    path = vim.fn.expand("%:p")
    if path ~= "" then
      vim.notify("Using current buffer path: " .. path, vim.log.levels.INFO)
    end
  end

  -- Fallback to current directory as last resort
  if not path or path == "" then
    path = vim.fn.getcwd()
    vim.notify("Using current directory: " .. path, vim.log.levels.INFO)
  end

  -- Path validation
  if not path or path == "" then
    vim.notify("Syft error: No valid path found", vim.log.levels.ERROR)
    return
  end

  -- Get absolute path
  local absolute_path = vim.fn.fnamemodify(path, ":p")

  -- Run Syft
  local output = vim.fn.getcwd() .. "/sbom.json"
  local cmd = string.format("/opt/homebrew/bin/syft '%s' -o json=%s", absolute_path, output)

  vim.notify("Executing command: " .. cmd, vim.log.levels.INFO)

  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Syft failed:\n" .. result, vim.log.levels.ERROR)
    return
  end

  vim.notify("SBOM written to " .. output, vim.log.levels.INFO)
  vim.cmd("edit " .. output)
end

return M
