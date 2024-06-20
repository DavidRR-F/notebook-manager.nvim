local utils = require('notebook_manager.utils')
local config = require('notebook_manager.config')
local PyProject = require('notebook_manager.toml_parcer.pyproject')
local KernelManager = require('notebook_manager.kernel_manager.kernel')

local M = {}

local pyproject = PyProject:new()
local kernel = KernelManager:new()

-- Create a Jupyter notebook
M.create_notebook = function(book_name)
  utils.ensure_directory_exists(config.options.dir)
  local notebook_file = book_name .. ".ipynb"
  local file_path = config.options.dir .. "/" .. notebook_file

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

  utils.create_file(file_path, vim.fn.json_encode(notebook))
  print("Notebook created: " .. notebook_file)
end

M.delete_notebook = function(book_name)
  local notebook_file = book_name .. ".ipynb"
  local file_path = config.options.dir .. "/" .. notebook_file
  if vim.fn.filereadable(file_path) == 1 then
    os.remove(file_path)
  else
    print("Notebook not found: " .. notebook_file)
    return
  end
  local jupytext_file = book_name .. ".py"
  local jupytext_path = config.options.dir .. "/" .. jupytext_file
  if vim.fn.filereadable(jupytext_path) == 1 then
    os.remove(jupytext_path)
  end
  print("Notebook deleted: " .. notebook_file)
end

M.create_kernel = function(kernel_name)
  kernel:create_kernel(kernel_name, pyproject.manager.cli)
end

M.delete_kernel = function(kernel_name)
  kernel:delete_kernel(kernel_name, pyproject.manager.cli)
end

-- Register Neovim commands
M.register_commands = function()
  vim.api.nvim_create_user_command('CreateBook', function(opts)
    M.create_notebook(opts.args)
  end, { nargs = '?' })
  vim.api.nvim_create_user_command('DeleteBook', function(opts)
    M.delete_notebook(opts.args)
  end, { nargs = '?' })
  vim.api.nvim_create_user_command('CreateKernel', function(opts)
    M.create_kernel(opts.args)
  end, { nargs = '?' })
  vim.api.nvim_create_user_command('DeleteKernel', function(opts)
    M.delete_kernel(opts.args)
  end, { nargs = '?' })
end

return M
