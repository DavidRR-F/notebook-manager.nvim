local PackageManagerBase = require('notebook_manager.packages.base')

local Rye = {}
Rye.__index = Rye
setmetatable(Rye, { __index = PackageManagerBase })

function Rye:new(config)
  local instance = setmetatable({}, Rye)
  instance.cli = "rye"
  instance.config = config
  return instance
end

function Rye:get_project_name()
  return self.config.project_name or "Unknown"
end

function Rye:get_project_description()
  return self.config.project_description or "No description"
end

function Rye:get_project_author()
  if self.config.project_authors then
    return table.concat(self.config.project_authors, ", ")
  end
  return "Unknown"
end

function Rye:get_project_version()
  return self.config.requires.python_version or "Unknown version"
end

return Rye
