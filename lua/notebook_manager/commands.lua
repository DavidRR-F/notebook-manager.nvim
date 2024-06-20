local utils = require('notebook_manager.utils')
local config = require('notebook_manager.config')
local PyProject = require('notebook_manager.toml_parcer.pyproject')
local KernelManager = require('notebook_manager.kernel_manager.kernel')

local M = {}

local pyproject = PyProject:new()
local kernel = KernelManager:new()

M.create_notebook = function(book_name)
  utils.ensure_directory_exists(config.options.dir)
  local notebook_file = book_name .. ".ipynb"
  local file_path = config.options.dir .. "/" .. notebook_file
  local notebook = pyproject:notebook_metadata(notebook_file)
  utils.create_file(file_path, vim.fn.json_encode(notebook))
  print("Notebook created: " .. notebook_file)
end

M.delete_notebook = function(book_name)
  local notebook_files = { book_name .. ".ipynb", book_name .. ".py" }
  for i = 1, #notebook_files do
    local file_path = config.options.dir .. "/" .. notebook_files[i]
    if vim.fn.filereadable(file_path) == 1 then
      os.remove(file_path)
      print("Notebook Removed: " .. notebook_files[i])
    end
  end
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
