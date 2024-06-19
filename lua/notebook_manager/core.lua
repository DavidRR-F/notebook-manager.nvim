local M = {}

-- Load configurations and utility functions
local commands = require('notebook_manager.commands')

-- Initialize plugin
M.setup = function()
    -- Register commands
    commands.register_commands()
end

return M

