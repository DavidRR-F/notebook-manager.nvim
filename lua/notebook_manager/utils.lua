local uv = vim.loop
local Path = require('plenary.path')
local config = require('notebook_manager.config')
local M = {}

local function ensure_directory_exists(dir)
  local path = Path:new(dir)
  if not path:exists() then
    path:mkdir({ parents = true })
  end
end

M.create_book = function(file_name)
  local file_path = config.options.dir .. "/" .. file_name .. ".ipynb"
  ensure_directory_exists(config.options.dir)
  print("Creating book: " .. file_name)
end

return M
