local Path = require('plenary.path')
local PyProject = require('notebook_manager.toml_parcer.pyproject')
local M = {}

M.ensure_directory_exists = function(dir)
  local path = Path:new(dir)
  if not path:exists() then
    path:mkdir({ parents = true })
  end
end

M.get_project_info = function()
  local pyproject = PyProject:new()
  print(pyproject.project_name)
end


return M
