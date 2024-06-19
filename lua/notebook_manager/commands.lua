local utils = require('notebook_manager.utils')

local M = {}

-- Create a Jupyter notebook
M.create_notebook = function(file_name)
    utils.create_book(file_name)
end

-- Register Neovim commands
M.register_commands = function()
    vim.api.nvim_create_user_command('CreateBook', function(opts)
        M.create_notebook(opts.args)
    end, { nargs = '?' })
end

return M
