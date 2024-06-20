local PackageManagerBase = require('notebook_manager.packages.base')

local Poetry = {}
Poetry.__index = Poetry
setmetatable(Poetry, { __index = PackageManagerBase })

function Poetry:new(config)
  local instance = setmetatable({}, Poetry)
  instance.cli = "poetry"
  instance.config = config
  return instance
end

function Poetry:get_project_name()
  return self.config.tool.poetry.name or "Unknown"
end

function Poetry:get_project_description()
  return self.config.tool.poetry.description or "No description"
end

function Poetry:get_project_author()
  if self.config.tool.poetry.authors then
    return table.concat(self.config.tool.poetry.authors, ", ")
  end
  return "Unknown"
end

function Poetry:get_project_version()
  return self.config.tool.poetry.dependencies.python or "Unknown version"
end

return Poetry
