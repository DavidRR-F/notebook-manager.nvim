local utils = require('notebook_manager.utils')
local config = require('notebook_manager.config')
local TomlManager = require('notebook_manager.toml.manager')
local KernelManager = require('notebook_manager.kernel.manager')
local KernelMenu = require('notebook_manager.kernel.menu')

local M = {}

local project = TomlManager:get_instance()
local kernel = KernelManager:get_instance()
local menu = KernelMenu:get_instance()


M.create_notebook = function(book_name)
  utils.ensure_directory_exists(config.options.notebook_dir)
  local notebook_file = book_name .. ".ipynb"
  local file_path = config.options.notebook_dir .. "/" .. notebook_file
  local metedata
  if project and not config.options.ignore_package_manager then
    metedata = project:notebook_metadata(notebook_file)
  else
    metedata = utils.generic_metadata(notebook_file)
  end
  local created = utils.create_file(file_path, vim.fn.json_encode(metedata))
  if created then
    print("Notebook created: " .. notebook_file)
  else
    print("Notebook already exists: " .. notebook_file)
  end
end

M.delete_notebook = function(book_name)
  local notebook_files = { ".ipynb", ".py" }
  local removed = false
  for i = 1, #notebook_files do
    local file_path = config.options.notebook_dir .. "/" .. book_name .. notebook_files[i]
    if vim.fn.filereadable(file_path) == 1 then
      os.remove(file_path)
      removed = true
    end
  end

  if not removed then
    print("Notebook not found: " .. book_name)
  else
    print("Notebook deleted: " .. book_name)
  end
end

M.create_kernel = function(kernel_name)
  if config.options.ignore_package_manager then
    kernel:create_kernel(kernel_name)
  else
    kernel:create_kernel(kernel_name, project)
  end
end

M.delete_kernel = function(kernel_name)
  if config.options.ignore_package_manager then
    kernel:delete_kernel(kernel_name)
  else
    kernel:delete_kernel(kernel_name, project)
  end
end

M.kernel_menu_show = function()
  menu:show()
end

M.kernel_menu_delete = function()
  menu:delete()
end

M.kernel_menu_create = function()
  menu:create()
end

M.kernel_menu_close = function()
  menu:close()
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
  vim.api.nvim_create_user_command('KernelMenu', function()
    M.kernel_menu_show()
  end, { nargs = '?' })
end

return M
