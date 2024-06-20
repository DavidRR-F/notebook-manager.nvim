local toml = require("notebook_manager.toml.parcer")
local PackageManagerFactory = require("notebook_manager.packages.factory")

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

function TomlManager:new()
  local instance = setmetatable({}, mt)
  instance.file = instance:find()
  instance.manager = instance:load()
  return instance
end

function TomlManager:find()
  local toml_files = { "pyproject.toml", "Pipfile" }
  for i = 1, #self.toml_files do
    if vim.fn.filereadable(toml_files[i]) == 1 then
      return toml_files[i]
    end
  end
  return nil
end

function TomlManager:load()
  local file = io.open(self.file, "r")
  if file then
    local contents = file:read("*all")
    file:close()
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
