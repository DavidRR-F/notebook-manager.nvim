local toml = require("notebook_manager.toml.parcer")
local PackageManagerFactory = require("notebook_manager.packages.factory")
local utils = require("notebook_manager.utils")
local Path = require("plenary.path")

TomlManager = {}
TomlManager.__index = TomlManager

local mt = {
  __index = function(tbl, key)
    if key == "name" then
      return tbl.manager:get_project_name()
    elseif key == "description" then
      return tbl.manager:get_project_description()
    elseif key == "author" then
      return tbl.manager:get_project_author()
    elseif key == "python_version" then
      return tbl.manager:get_project_version()
    else
      return rawget(tbl, key) or TomlManager[key]
    end
  end
}

local function new(file_path)
  if not file_path then
    return nil
  end
  local instance = setmetatable({}, mt)
  instance.file = file_path
  instance.manager = instance:load()
  return instance
end

function TomlManager:get_instance()
  if not self.instance then
    self.instance = new(utils.get_toml_path())
  end
  return self.instance
end

function TomlManager:load()
  local path = Path:new(self.file)
  if path:exists() then
    local contents = path:read()
    return PackageManagerFactory:createManager(toml.parse(contents), self.file)
  end
  return nil
end

function TomlManager:notebook_metadata(name)
  return {
    cells = {
      {
        cell_type = "code",
        execution_count = nil,
        id = "95a5baa1",
        metadata = { empty = true },
        outputs = {},
        source = { "" }
      },
    },
    metadata = {
      kernelspec = {
        name = "python3",
        display_name = "Python 3",
        language = "python"
      },
      language_info = {
        name = "python",
        version = self.python_version,
        mimetype = "text/x-python",
        codemirror_mode = {
          name = "ipython",
          version = 3
        },
        pygments_lexer = "ipython3",
        nbconvert_exporter = "python",
        file_extension = ".py"
      },
      version = "1.0",
      author = self.author,
      description = self.description,
      name = name
    },
    nbformat = 4,
    nbformat_minor = 5
  }
end

return TomlManager
