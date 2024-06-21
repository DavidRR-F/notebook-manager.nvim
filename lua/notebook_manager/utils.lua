local Path = require('plenary.path')

local M = {}

M.ensure_directory_exists = function(dir)
  local path = Path:new(dir)
  if not path:exists() then
    path:mkdir({ parents = true })
  end
end

M.create_file = function(file, content)
  local path = Path:new(file)
  if not path:exists() then
    path:touch()
    path:write(content, 'w')
    return true
  end
  return false
end

M.get_toml_path = function()
  local toml_files = { "pyproject.toml", "Pipfile" }
  for i = 1, #toml_files do
    if vim.fn.filereadable(toml_files[i]) == 1 then
      return toml_files[i]
    end
  end
  return nil
end

M.generic_metadata = function(notebook_file)
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
        version = "3",
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
      name = notebook_file
    },
    nbformat = 4,
    nbformat_minor = 5
  }
end

return M
