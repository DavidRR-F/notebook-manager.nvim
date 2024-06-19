local PackageManagerBase = require('notebook_manager.package_manager.base')

local PackageManagerPoetry = {}
PackageManagerPoetry.__index = PackageManagerPoetry
setmetatable(PackageManagerPoetry, { __index = PackageManagerBase })

function PackageManagerPoetry:new(config)
  local instance = setmetatable({}, PackageManagerPoetry)
  instance.config = config
  return instance
end

function PackageManagerPoetry:get_project_name()
  return self.config.tool.poetry.name or "Unknown"
end

function PackageManagerPoetry:get_project_description()
  return self.config.tool.poetry.description or "No description"
end

function PackageManagerPoetry:get_project_author()
  if self.config.tool.poetry.authors then
    return table.concat(self.config.tool.poetry.authors, ", ")
  end
  return "Unknown"
end

function PackageManagerPoetry:get_project_version()
  return self.config.tool.poetry.version or "Unknown version"
end

return PackageManagerPoetry
