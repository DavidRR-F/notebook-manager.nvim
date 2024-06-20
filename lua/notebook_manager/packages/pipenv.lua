local PackageManagerBase = require('notebook_manager.packages.base')

local Pipenv = {}
Pipenv.__index = Pipenv
setmetatable(Pipenv, { __index = PackageManagerBase })

function Pipenv:new(config)
  local instance = setmetatable({}, Pipenv)
  instance.cli = "pipenv"
  instance.config = config
  return instance
end

function Pipenv:get_project_name()
  return self.config.project_name or "Unknown"
end

function Pipenv:get_project_description()
  return self.config.project_description or "No description"
end

function Pipenv:get_project_author()
  if self.config.project_authors then
    return table.concat(self.config.project_authors, ", ")
  end
  return "Unknown"
end

function Pipenv:get_project_version()
  return self.config.requires.python_version or "Unknown version"
end

return Pipenv
