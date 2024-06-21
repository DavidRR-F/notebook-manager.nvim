local config = require('notebook_manager.config')

local M = {}

M.register_keymaps = function()
  for _, keymap in ipairs(config.keymaps) do
    local lhs, rhs, desc = keymap[1], keymap[2], keymap.desc or ""
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true, desc = desc })
  end
end

return M
