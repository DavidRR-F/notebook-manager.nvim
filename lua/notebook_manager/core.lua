local M = {}

local commands = require('notebook_manager.commands')

M.setup = function()
  commands.register_commands()
end

return M
