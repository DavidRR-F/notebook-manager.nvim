local PackageManagerPoetry = require('notebook_manager.package_manager.poetry')

local PackageManagerFactory = {}
PackageManagerFactory.__index = PackageManagerFactory

function PackageManagerFactory:createManager(config)
  if config.tool.poetry ~= nil then
    return PackageManagerPoetry:new(config)
  elseif config.tool.rye ~= nil then
    return ""
  else
    error("Invalid/Unsupported toml configuration")
  end
end

return PackageManagerFactory
