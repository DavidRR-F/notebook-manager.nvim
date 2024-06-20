local toml = require("notebook_manager.toml_parcer.toml")
local PackageManagerFactory = require("notebook_manager.package_manager.factory")

PyProject = {}
PyProject.__index = PyProject

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
      return rawget(tbl, key) or PyProject[key]
    end
  end
}

function PyProject:new(file_path)
  local instance = setmetatable({}, mt)
  instance.file_path = file_path or "pyproject.toml"
  instance.manager = PackageManagerFactory:createManager(instance:load(file_path))
  return instance
end

function PyProject:load()
  local file = io.open(self.file_path, "r")
  if not file then
    return nil
  end
  local contents = file:read("*all")
  file:close()
  return toml.parse(contents)
end

function PyProject:notebook_metadata(name)
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

return PyProject
