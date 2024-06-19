local utils = require('notebook_manager.utils')
local config = require('notebook_manager.config')
local M = {}

-- Create a Jupyter notebook
M.create_notebook = function(file_name)
  utils.ensure_directory_exists(config.options.dir)
  local notebook_file = file_name .. ".ipynb"
  local file_path = config.options.dir .. "/" .. notebook_file

  local pyproject = utils.get_project_info()

  local notebook = {
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
        version = pyproject.python_version,
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
      author = pyproject.author,
      description = pyproject.description,
      name = notebook_file
    },
    nbformat = 4,
    nbformat_minor = 5
  }

  utils.create_file(file_path, notebook)
  print("Notebook created: " .. notebook_file)
end

-- Register Neovim commands
M.register_commands = function()
  vim.api.nvim_create_user_command('CreateBook', function(opts)
    M.create_notebook(opts.args)
  end, { nargs = '?' })
end

return M
