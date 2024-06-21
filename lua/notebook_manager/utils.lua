local Path = require('plenary.path')
local popup = require('plenary.popup')

local M = {}

M.ensure_directory_exists = function(dir)
  local path = Path:new(dir)
  if not path:exists() then
    path:mkdir({ parents = true })
  end
end

M.create_file = function(file, content)
  local path = Path:new(file)
  if not path:exists() then
    path:touch()
    path:write(content, 'w')
    return true
  end
  return false
end

return M
