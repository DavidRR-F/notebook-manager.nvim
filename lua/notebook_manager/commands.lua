local utils = require('notebook_manager.utils')
local config = require('notebook_manager.config')
local M = {}

-- Create a Jupyter notebook
M.create_notebook = function(file_name)
  --utils.ensure_directory_exists(config.options.dir)
  local notebook_file = file_name .. ".ipynb"
  local file_path = config.options.dir .. "/" .. notebook_file

  utils.get_project_info()
  print("Notebook created: " .. notebook_file)
end

-- Register Neovim commands
M.register_commands = function()
  vim.api.nvim_create_user_command('CreateBook', function(opts)
    M.create_notebook(opts.args)
  end, { nargs = '?' })
end

return M
