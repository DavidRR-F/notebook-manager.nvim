local utils = require('notebook_manager.utils')
local config = require('notebook_manager.config')
local TomlManager = require('notebook_manager.toml.manager')
local KernelManager = require('notebook_manager.kernel.manager')

local M = {}

local project = TomlManager:new()
local kernel = KernelManager:new()

M.create_notebook = function(book_name)
  utils.ensure_directory_exists(config.options.dir)
  local notebook_file = book_name .. ".ipynb"
  local file_path = config.options.notebook_dir .. "/" .. notebook_file
  local notebook = project:notebook_metadata(notebook_file)
  local created = utils.create_file(file_path, vim.fn.json_encode(notebook))
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
  kernel:create_kernel(kernel_name, project.manager.cli)
end

M.delete_kernel = function(kernel_name)
  if not kernel_name then
    local buf = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local kernels = vim.api.nvim_buf_get_var(buf, 'kernels')
    kernel_name = kernels[line]
  end

  if kernel_name then
    local fn = function(param)
      kernel:delete_kernel(param, project.manager.cli)
    end
    utils.confirm_prompt('Delete kernel: %s?', kernel_name, fn)
  else
    vim.notify('No kernel name provided.', vim.log.levels.ERROR)
  end
end

M.show_kernels = function()
  local kernels = kernel:get_kernels(project.manager.cli)
  if vim.tbl_isempty(kernels) then
    vim.notify('No Jupyter kernels found.')
    return
  end

  local window_options = {
    title = 'Jupyter Kernels',
    width = 50,
    height = 20,
  }

  local menu = utils.menu(kernels, window_options)

  local buf = vim.api.nvim_win_get_buf(menu)

  -- Register keymaps
  vim.api.nvim_buf_set_keymap(buf, 'n', 'd',
    [[<cmd>lua require('notebook_manager.commands').delete_kernel()<CR>]],
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>bwipeout!<CR>', { noremap = true, silent = true })

  -- Disable left/right movement
  vim.api.nvim_buf_set_keymap(buf, 'n', 'h', '', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'l', '', { noremap = true, silent = true })

  -- Disable movement in the header
  vim.api.nvim_buf_set_keymap(buf, 'n', 'k', 'gk', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'j', 'gj', { noremap = true, silent = true })
  vim.api.nvim_buf_set_var(buf, 'kernels', kernels)
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
  vim.api.nvim_create_user_command('ShowKernels', function()
    M.show_kernels()
  end, { nargs = '?' })
end

return M
