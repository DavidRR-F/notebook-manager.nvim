local PackageManagerBase = {}
PackageManagerBase.__index = PackageManagerBase

local mt = {
  __index = function(table, key)
    if key == "name" then
      return table:get_project_name()
    elseif key == "description" then
      return table:get_project_description()
    elseif key == "author" then
      return table:get_project_author()
    elseif key == "version" then
      return table:get_project_version()
    else
      return rawget(table, key)
    end
  end
}

function PackageManagerBase:new(config)
  error("Subclass must implement new method")
end

function PackageManagerBase:get_project_name()
  error("Subclass must implement get_project_name method")
end

function PackageManagerBase:get_project_description()
  error("Subclass must implement get_project_description method")
end

function PackageManagerBase:get_project_author()
  error("Subclass must implement get_project_author method")
end

function PackageManagerBase:get_project_version()
  error("Subclass must implement get_project_version method")
end

return PackageManagerBase
