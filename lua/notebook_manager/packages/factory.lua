local Poetry = require('notebook_manager.packages.poetry')
local Rye = require('notebook_manager.packages.rye')
local Pipenv = require('notebook_manager.packages.pipenv')

local PackageManagerFactory = {}
PackageManagerFactory.__index = PackageManagerFactory

function PackageManagerFactory:createManager(config, file)
  if file == "pyproject.toml" then
    if config.tool.poetry ~= nil then
      return Poetry:new(config)
    elseif config.tool.rye ~= nil then
      return Rye:new(config)
    end
  elseif file == "Pipfile" then
    return Pipenv:new(config)
  else
    return nil
  end
end

return PackageManagerFactory
