local M = {}

local commands = require('notebook_manager.commands')
local keymaps = require('notebook_manager.keymaps')

M.setup = function()
  commands.register_commands()
  keymaps.register_keymaps()
end

return M
